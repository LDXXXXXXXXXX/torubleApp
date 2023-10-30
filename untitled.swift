let queue = DispatchQueue.global(qos: .userInteractive)
            
            
            queue.sync {
                
                if let imageData = avatar.jpegData(compressionQuality: 0.8) {
                    
                    refStorage.putData(imageData) { metadata, errorStorage in
                        
                        if let errorStorage = errorStorage {
                            
                            print("ERROR STORAGE UPLOAD IMAGE AVATAR : \(errorStorage)")
                            
                        } else {
                            
                            print("Аватарка успешно загружена!!!")
                            
                            self.refStorage.downloadURL { url, errorURL in
                                
                                if let errorURL = errorURL {
                                    
                                    print("ERROR STORAGE GETING URL FROM IMAGE AVATAR : \(errorURL)")
                                    
                                } else {
                                    
                                    if let imageURL = url {
                                        print("URL загруженного изображения: \(imageURL.absoluteString)")
                                        self.urlOfImage = imageURL.absoluteString
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            queue.sync {
                
                let parameters : [String : Any] = [
                    
                    "name": name,
                    "surname": surname,
                    "avatarURL" : urlOfImage,
                    "uid" : KeychainWrapper.standard.string(forKey: "uid")!
                
                ]
                
                ref.collection("users").addDocument(data: parameters) { error in
                    
                    if let error = error {
                        
                        print("ERROR ADD USER DATA TO FIRESTORE: \(error)")
                        
                    } else {
                        
                        self.router.openFullScreenViewController(rootViewController: viewController, openViewController: TabBarController())
                        
                    }
                    
                }
            }