//
//  PrompotsViewModel.swift
//  MCL
//
//  Created by Eduardo Gonzalez Melgoza on 31/05/24.
//

import Foundation
import SwiftUI

class PromptsViewModel: ObservableObject {
    @Published var albumPrompts: [String] = [
        "How does this album resonate with your personal experiences or memories?",
        "How has this album influenced your life or changed your perspective on certain things?",
        "What emotions does this album evoke in you, and why?",
        "How does this album reflect or influence the culture or era in which it was released?",
        "In what ways has this album inspired your own creativity or artistic pursuits?",
        "How has this album affected or been affected by social movements or events?",
        "How does this album relate to your sense of identity or belonging to a particular community or group?",
        "How has this album contributed to the evolution of your musical tastes?",
        "Do you have any shared experiences with friends or family that are connected to this album?",
        "How has this album influenced or been represented in other media, such as films, books, or visual art?",
        "What do you appreciate about the album's sound quality, production techniques, or overall aesthetic?",
        "What legacy has this album left in the music world or in your own life?",
        "How have you grown or changed since you first heard this album?",
        "Where and how do you prefer to listen to this album, and why does that setting enhance the experience for you?",
        "How does this album compare to others in the same genre or by the same artist, in terms of its importance to you?",
        "What was your first impression of this album, and how has your perception of it changed over time?",
        "What do you think about the album cover art and its connection to the music and themes?",
        "How do you feel about the critical reception of the album, and do you agree or disagree with the critics?",
        "Without focusing on individual songs, what overarching themes or messages do you think the album conveys?",
        "Do you have any personal rituals or traditions associated with listening to this album?",
        "What role did this album play during a specific period of your life?",
        "How does the album's structure (e.g., track order, flow) contribute to its overall impact?",
        "What memories do you have of the first time you listened to this album?",
        "How does this album compare to the artist's other works in terms of its significance to you?",
        "What elements of this album make it timeless or particularly relevant to you?",
        "How does this album make you feel about the artist as a person or their journey?",
        "What has this album taught you about a particular genre or style of music?",
        "How does this album challenge or reinforce your beliefs or values?",
        "What visual or sensory experiences does this album evoke for you?",
        "How has your appreciation for this album evolved over repeated listens?",
        "In what ways does this album connect to significant historical or social contexts?",
        "How does this album's mood or tone influence your listening experience?",
        "What stories or narratives do you associate with this album?",
        "How has this album helped you through difficult times or celebrated happy moments?",
        "What philosophical or existential questions does this album raise for you?",
        "How does this album's instrumentation or arrangement stand out to you?",
        "What role does this album play in your collection of music?",
        "How does this album compare to live performances by the artist?",
        "What future significance do you think this album will hold for you?",
        "How does this album contribute to your understanding or appreciation of music as an art form?"
    ]

    
    @Published var songPrompts: [String] = [
        "How does this song resonate with your personal experiences?",
        "How does this song influence your emotions?",
        "What do you find most creatively inspiring about this song?",
        "How has this song impacted your life?",
        "What specific memory does this song remind you of?",
        "What do you appreciate about the production techniques used in this song?",
        "How does this song reflect your sense of identity?",
        "What do you find most lyrically compelling about this song?",
        "How has your interpretation of this song changed over time?",
        "What visual imagery comes to mind when you listen to this song?",
        "How do you connect with this song during different seasons or times of the year?",
        "How does this song compare to others by the same artist?",
        "What makes this song timeless for you?",
        "How does this song help you through difficult times?",
        "What memories are associated with this song?",
        "What do you find most musically innovative about this song?",
        "How does this song challenge or reinforce your beliefs?",
        "What makes this song stand out instrumentally?",
        "How do you interpret the mood or tone of this song?",
        "What role does this song play in your personal playlist?",
        "How does this song compare to live performances by the artist?",
        "How do you enjoy listening to this song in different environments?",
        "How does this song influence your creative process?",
        "What philosophical or existential questions does this song raise for you?",
        "How do you feel about the critical reception of this song?",
        "What overarching themes do you find in this song?",
        "Why do you share this song most often with others?",
        "How does this song contribute to the overall story or message of the album?",
        "What personal growth do you associate with this song?",
        "How does this song reflect or influence the culture or era in which it was released?",
        "What do you think are the most impactful lyrics in this song?",
        "What sensory experiences does this song evoke?",
        "How does this song compare to others in the same genre?",
        "What was your first impression of this song?",
        "What do you think best showcases the artist's talents in this song?",
        "How do you interpret the narrative or story within this song?",
        "Why do you consider this song the most underrated or overlooked?",
        "What emotions do you experience when listening to this song?",
        "How does this song connect to significant events in your life?",
        "How has this song grown on you over time?"
    ]

    
    func getRandomAlbumPrompt() -> String {
        return albumPrompts.randomElement() ?? "No prompt available"
    }
    
    func getRandomSongPrompt() -> String {
        return songPrompts.randomElement() ?? "No prompt available"
    }
}
