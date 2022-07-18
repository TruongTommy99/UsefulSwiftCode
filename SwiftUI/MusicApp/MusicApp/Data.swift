//
//  Data.swift
//  MusicApp
//
//  Created by Truong Tommy on 6/9/22.
//
import Foundation
import SwiftUI
import Firebase

class OurData : ObservableObject {
    @Published public var albums = [Album]() 
    
    
    func loadAlbums() {
        Firestore.firestore().collection("albums").getDocuments { (snapchot,error) in
            if error == nil {
                for document in snapchot!.documents {
                    let name = document.data()["name"] as? String ?? "error"
                    let image = document.data()["image"] as? String ?? "1"
                    let songs = document.data()["songs"] as? [String:[String : Any]]
                    
                    
                    var songsArray = [Song]()
                    if let songs = songs {
                        for song in songs {
                            let songName = song.value["name"] as? String ?? "error"
                            let songTime = song.value["time"] as? String ?? "noTime"
                            let songFile = song.value["file"] as? String ?? "error"
        
                            songsArray.append(Song(name: songName, time: songTime,file: songFile))
                        }
                    }
                    self.albums.append(Album(name: name, image: image, songs: songsArray))
                    
                }
            }else{
                print(error)
            }
            
        }
    }
    
}




