//
//  JsonStructDecodable.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 11.11.2020.
//

import Foundation

// MARK: получение списка всех постов

// =====================================================================================
// /api/all_posts - получение списка всех постов
//  Заголовок GET-запроса: Accept - application/json
// =====================================================================================
// Ответ
// ===

struct PostsResponseJson: Decodable {
    var success: Bool?
    var data: [DataResponseJson]?
    var message: String?

}
struct DataResponseJson: Decodable {
    var post: PostResponseJson?
    var images: [ImagesResponseJson]?
    var comments: [CommentElementResponseJson]?
}

struct PostElementsResponseJson: Decodable {
    var post: PostResponseJson?
    var image: [ImagesResponseJson]?
}

struct PostResponseJson: Decodable {
    var id: Int?
    var title: String?
    var content: String?
    var user_id: Int?
    var created_at: String?
    var updated_at: String?
    var isCheckbox: Bool?
}

struct CommentsJson: Decodable {
    var comments: [CommentElementResponseJson]?
}

struct CommentElementResponseJson: Decodable {
    var comment: CommentResponseJson?
    var images: [ImagesResponseJson]?
}

struct ImagesResponseJson: Decodable {
    var id: Int?
    var link: String?
    var alt: String?
}

struct CommentResponseJson: Decodable {
    var id: Int?
    var text: String?
    var post_id: Int?
    var user_id: Int?
    var created_at: String?
    var updated_at: String?
    var isCheckbox: Bool?
}

// MARK: удаление комментария

// =====================================================================================
// /api/posts/1/comment/2 - удаление комментария (1 - id поста, 2 - id комментария)<br>
// Заголовоки DELETE-запроса:
// Accept - application/json
// Authorization - Bearer token
// =====================================================================================
// Ответ

struct CommentsDeletedJson: Decodable {
    var success: Bool?
    var data: CommentsDeletedDataJson?
    var message: String?
    
}

struct CommentsDeletedDataJson: Decodable {
    var comment: CommentsDeletedDataCommentJson?
    var images: [CommentsDeletedImagesJson]?
}

struct CommentsDeletedImagesJson: Decodable {
    var id: Int?
    var link: String?
    var alt: String?
}

struct CommentsDeletedDataCommentJson: Decodable {
    var id: Int?
    var text: String?
    var post_id: Int?
    var user_id: Int?
    var created_at: String?
    var updated_at: String?
    var user: CommentsDeletedUserJson?
}
struct CommentsDeletedUserJson: Decodable {
    var id: Int?
    var name: String?
    var email: String?
    var email_verified_at: String?
    var created_at: String?
    var updated_at: String?
    var address: String?
}


// MARK: получение данных пользователя

// =====================================================================================
// /api/profile - получение данных пользователя<br>
// Заголовоки GET-запроса:
// Accept - application/json
// Authorization - Bearer token
// =====================================================================================
// Ответ

struct ProfileJson: Decodable {
    var success: Bool?
    var data: UserProfileJson?
    var message: String?
}

struct UserProfileJson: Decodable {
    var id: Int?
    var name: String?
    var email: String?
    var email_verified_at: String?
    var created_at: String?
    var updated_at: String?
    var address: String?
}

// MARK: изменение данных пользователя

// =====================================================================================
// /api/profile/update - изменение данных пользователя
// Заголовоки PUT-запроса:
// Accept - application/json
// Authorization - Bearer token
// =====================================================================================
// Запрос

struct ProfileJsonSend: Codable {
    var name: String?
    var email: String?
    var password: String?
    var c_password: String?
    var address: String?
}
