//
//  HomeViewModel.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 26.12.2022.
//

import Foundation
import Modeling3dKit
import ZIPFoundation

typealias VoidHandler = () -> Void

protocol Model3dDelegate: AnyObject {
//    func showAlert(title: String, message: String)
}

class Model3dViewModel {
    weak var delegate: Model3dDelegate?
    var model = [Modeling3dReconstructTaskModel]()
    var currentCellIndex: Int?
    var actionTableReload: VoidHandler?
    
    func deleteForUpload(taskId: String){
        Modeling3dReconstructTask.sharedManager().deleteTask(withTaskId: taskId) {
            print("deleteForUpload success...")
        } failureHandler: { retCode, retMsg in
            print("deleteForUpload retCode:", retCode)
            print("deleteForUpload retMsg:", retMsg)
        }
    }
    
    func delete() {
        Modeling3dReconstructTask.sharedManager().deleteTask(withTaskId: self.model[currentCellIndex!].taskId) {
            print("Delete success...")
            self.model.remove(at: self.currentCellIndex!)
            self.actionTableReload?()
        } failureHandler: { retCode, retMsg in
            print("delete retCode:", retCode)
            print("delete retMsg:", retMsg)
        }
    }
    
    func upload(imageSet: [UIImage], viewController: UIViewController) {
        Modeling3dReconstructTask.sharedManager().taskType = 0
        Modeling3dReconstructTask.sharedManager().initTask(with: .pictureModel) { taskModel in
            Modeling3dReconstructTask.sharedManager().createLocationUrl(with: taskModel)
            Modeling3dReconstructTask.sharedManager().queryRestriction(withTaskId: taskModel.taskId) { restrictFlag in
                if (restrictFlag.rawValue != 1) {
                    let alert = ProgressAlertView(on: viewController, alertTitle: "Upload", isUpload: true, taskId: taskModel.taskId)
                    alert.deleteActionForUpload = {
                        self.deleteForUpload(taskId: taskModel.taskId)
                    }
                    
                    Modeling3dReconstructTask.sharedManager().uploadTask(with: taskModel, imageAssets: imageSet) { progress in
                        print("uploadTask progress:", progress)
                    } successHandler: {
                        print("uploadTask success")
                        taskModel.taskStatus = 1
                        taskModel.save()
                        
                        self.model.append(taskModel)
                        self.actionTableReload?()
                        alert.removeAlertView()
                    } progressHandler: { progressValue in
                        print("uploadTask progressValue:", progressValue)
                        alert.updateProgress(progressValue: progressValue)
                    } failureHandler: { retCode, retMsg in
                        print("uploadTask retCode:", retCode)
                        print("uploadTask retMsg:", retMsg)
                    }
                } else {
                    print("The task is restricted, operate before cancel restrict please")
                }
            } failureHandler: { retCode, retMsg in
                print("queryRestriction retCode:", retCode)
                print("queryRestriction retMsg:", retMsg)
            }
        } failureHandler: { retCode, retMsg in
            print("initTask retCode:", retCode)
            print("initTask retMsg:", retMsg)
        }
    }
    
    func query(viewController: UIViewController) {
        let alert = ActivityIndicatorAlertView(on: viewController, alertTitle: "Query")
        
        let timer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { timer in
            Modeling3dReconstructTask.sharedManager().queryTask(withTaskId: self.model[self.currentCellIndex!].taskId) { taskStatus, errorMsg in
                if self.model[self.currentCellIndex!].taskStatus == 0 {
                    print("model taskStatus: 0")
                }
                if self.model[self.currentCellIndex!].taskStatus != taskStatus.rawValue {
                    print("model taskStatus:", self.model[self.currentCellIndex!].taskStatus)
                    print("return taskStatus: ", taskStatus.rawValue)
                    
                    self.model[self.currentCellIndex!].taskStatus = Int(taskStatus.rawValue)
                    self.model[self.currentCellIndex!].save()
                }
                if taskStatus.rawValue >= 3{
                    alert.removeAlertView()
                    timer.invalidate()
                }
                print("query is ongoing...")
            } failureHandler: { retCode, retMsg in
                print("queryTask retCode:", retCode)
                print("queryTask retMsg:", retMsg)
            }
        }
        alert.cancelAction = {
            timer.invalidate()
        }
    }
    
    func download(viewController: UIViewController) {
        Modeling3dReconstructTask.sharedManager().queryRestriction(withTaskId: self.model[self.currentCellIndex!].taskId) { restrictFlag in
            if (restrictFlag.rawValue != 1) {
                let alert = ProgressAlertView(on: viewController, alertTitle: "Download", isUpload: false, taskId: self.model[self.currentCellIndex!].taskId)
                
                Modeling3dReconstructTask.sharedManager().downloadTask(withTaskId: self.model[self.currentCellIndex!].taskId, downloadFormat: Modeling3dKit.TaskDownloadFormat.OBJ) {
                    print("downloadTask success...")
                    alert.removeAlertView()
                    // There are some issues caused by downloadTask method of Modeling3dKit.
                    // That's why alertview does not disappear.
                } progressHandler: { progressValue in
                    print("downloadTask progressValue:", progressValue)
                    alert.updateProgress(progressValue: progressValue)
                } failureHandler: { retCode, retMsg in
                    print("downloadTask retCode:", retCode)
                    print("downloadTask retMsg:", retMsg)
                }
            } else {
                print("The task is restricted, operate before cancel restrict please")
            }
        } failureHandler: { retCode, retMsg in
            print("queryRestriction retCode:", retCode)
            print("queryRestriction retMsg:", retMsg)
        }
    }
    
    func preview() {
        var directory: URL {
            get {
                return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0].appendingPathComponent("Caches").appendingPathComponent("dataTask")
                    .appendingPathComponent(self.model[self.currentCellIndex!].taskId).appendingPathComponent("downloadModel")
            }
        }
        print("directory: ", directory)
        let lastPath = directory.appendingPathComponent("model.zip")
        print("lastPath: ", lastPath)
        
        if !FileManager.default.fileExists(atPath: lastPath.path) {
//            self.delegate?.showAlert(title: "Download Error", message: "Not downloaded. Please download first.")
            print("not downloaded.")
        } else {
            let destinationURL = directory.appendingPathComponent("model")
            print("destinationURL: ", destinationURL)
            let mtlURL = destinationURL.appendingPathComponent("mesh_texture.mtl")
            print("mtlURL: ", mtlURL)
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                do {
                    try FileManager().createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                    try FileManager().unzipItem(at: lastPath, to: destinationURL)
                    
                    self.deleteMtlFile(mtlURL: mtlURL)
                    self.reWrite(mtlURL: mtlURL)
                } catch {
                    print("Extraction of ZIP archive failed with error:\(error)")
                }
            }
            self.deleteMtlFile(mtlURL: mtlURL)
            self.reWrite(mtlURL: mtlURL)
        }
    }
    
    func deleteMtlFile(mtlURL: URL) {
        do {
            try FileManager.default.removeItem(atPath: mtlURL.path)
            print("File deleted")
            return
        }
        catch {
            print("Error")
        }
    }
    
    func reWrite(mtlURL: URL) {
        let outString = "newmtl material\nmap_Kd mesh_texture_material_map_Kd.jpg\n"
        do {
            try outString.write(to: mtlURL, atomically: true, encoding: .utf8)
        } catch {
            assertionFailure("Failed writing to URL: \(mtlURL), Error: " + error.localizedDescription)
        }
    }
}
