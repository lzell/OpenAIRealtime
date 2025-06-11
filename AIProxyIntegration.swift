//
//  AIProxyIntegration.swift
//  OpenAIRealtime
//
//  Created by Lou Zell on 6/10/25.
//
import AIProxy

enum AIProxyIntegration {

    // #error("You must fill in details using one of the approaches below. Then delete this line.")

    // Use this service for prototyping only.
    // You must not distribute your app with this approach.
    static let openAIService = AIProxy.openAIDirectService(
        unprotectedAPIKey: "your-openai-secret-key"
    )

    // Use this service for shipping your app.
    // static let openAIService = AIProxy.openAIService(
    //     partialKey: "partial-key-from-aiproxy-dashboard",
    //     serviceURL: "service-url-from-aiproxy-dashboard"
    // )
}
