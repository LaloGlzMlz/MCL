//
//  PrompotsViewModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 31/05/24.
//

import Foundation
import SwiftUI

class PromptsViewModel: ObservableObject {
    @Published var prompts: [String] = [
        "How does this album relate to a specific time or event in your life?",
        "Does the album remind you of a particular person or place?",
        "What emotions do you feel when listening to this album?",
        "Are there specific songs that make you feel particularly happy, sad, or nostalgic?",
        "How has this album inspired you or influenced your actions?",
        "Have any of the lyrics or melodies sparked a creative idea or project for you?",
        "Do any songs on this album remind you of significant milestones in your life?",
        "Are there any memories that come to mind when you hear a particular track?",
        "Have you shared this album with friends or family? How did they react?",
        "Did you attend a concert or event related to this album with someone special?",
        "How does this album affect your mood or the atmosphere around you?",
        "Do you find yourself listening to this album in certain settings or situations?",
        "Are there specific lyrics that resonate with you? Why?",
        "What messages or themes from this album stand out to you the most?",
        "What aspects of the music (melody, rhythm, instrumentation) do you appreciate the most?",
        "How does the music compare to other albums or artists you enjoy?",
        "How has your perception of this album changed over time?",
        "Has this album helped you through any transitions or challenges?",
        "In what ways has this album contributed to your personal growth or self-discovery?",
        "How does listening to this album make you reflect on who you are or who you want to become?",
        "Which track on the album is your favorite and why?",
        "How do you feel when you listen to your favorite track on the album?",
        "How does the album cover art or any associated imagery enhance your experience of the music?",
        "Does the visual aspect of the album tell a story or add another layer to the music for you?",
        "How do you think this album has impacted the music industry or culture at large?",
        "Are there any societal or cultural themes in the album that resonate with you?",
        "How does this album compare to other albums by the same artist?",
        "What makes this album stand out compared to others in your collection?",
        "If this album were a soundtrack to a chapter in your life, which chapter would it be?",
        "How does the album's progression mirror or contrast your personal experiences?"
    ]
    
    func getRandomPrompt() -> String {
        return prompts.randomElement() ?? "No prompt available"
    }
}
