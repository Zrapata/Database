//
//  IntentHandler.swift
//  Intent
//
//  Created by Alejandro Bacelis on 22/11/21.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    var container = PersistenceController(from: "siri_extension").container
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
//        print("testing something in handler: ------ :")
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INSendMessageRecipientResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INSendMessageRecipientResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        } else {
            completion([INSendMessageRecipientResolutionResult.needsValue()])
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}

// MARK: - Get Available Items from Core Data
extension IntentHandler {
    var latestWorkspace: String {
        "WorkSpace"
    }
    
    typealias WorkspaceName = String
    typealias ProjectName = String
    
    func lastUsedWorkspace() -> WorkspaceIntent? {
        if let lastWorkspaceID = UserDefaults.standard.url(forKey: "selected_workspace") {
            if let lastWorkspace = WorkSpace.fetchObject(from: lastWorkspaceID, using: container.viewContext)?.intentValue {
                return lastWorkspace
            }
        }
        
        return WorkSpace.fetchAllObjects(in: container.viewContext).first?.intentValue
    }
    
    func availableWorkspaceIntents() -> INObjectCollection<WorkspaceIntent> {
        let worksapces = WorkSpace.fetchAllObjects(in: container.viewContext)
        
        return INObjectCollection(items: worksapces.intentValues())
    }
    func availableProjectIntents(in workspace: WorkspaceIntent?) -> INObjectCollection<ProjectIntent> {
        let workspaceID = URL(string: workspace?.identifier ?? "")
        let projects = Project.getAllProjects(in: workspaceID, with: container.viewContext)
        
        return INObjectCollection(items: projects.intentValues())
    }
    
    func handleResolveWorkspaces(self workspace: WorkspaceIntent?, project: ProjectIntent?) -> WorkspaceIntentResolutionResult {
        let workspaceID = URL(string: workspace?.identifier ?? "") ?? emptyCoreDataURL
        
        if let workspace = WorkSpace.fetchObject(from: workspaceID, using: container.viewContext) {
            return .success(with: workspace.intentValue)
        }
        
        let projectID = URL(string: project?.identifier ?? "") ?? emptyCoreDataURL
        if let _ = Project.fetchObject(from: projectID, using: container.viewContext) {
            return .notRequired()
        }
        
        return .needsValue()
    }
    func handleResolveProject(self project: ProjectIntent?, table: TableIntent?) -> ProjectIntentResolutionResult {
        let projectID = URL(string: project?.identifier ?? "") ?? defatultProjectID
        if let project = Project.fetchObject(from: projectID, using: container.viewContext) {
            return .success(with: project.intentValue)
        }
        
        return .needsValue()
    }
    
    func getWorkSpaces() throws -> [WorkSpace] {
        try container.viewContext.fetch(WorkSpace.fetchRequest())
    }
    var mostRecentWorkspace: WorkSpace? {
        var mostRecentDate: Date = .distantPast
        var workspace: WorkSpace? = nil
        do {
            try getWorkSpaces().forEach { ws in
                if ws.lastModifiedAt > mostRecentDate {
                    workspace = ws
                    mostRecentDate = ws.lastModifiedAt
                }
            }
            return workspace
        } catch {
            return nil
        }
    }
    
    func getProjects(for thisWorkspace: WorkspaceName? = nil) throws -> [Project] {
        let workspace: String
        if let thisWorkspace = thisWorkspace {
            workspace = thisWorkspace
        } else {
            workspace = latestWorkspace
        }
        
        let projects = try container.viewContext.fetch(Project.fetchRequest())
        let availableProjects = projects.filter({ $0.workspace?.storedItemName == workspace })
        return availableProjects
    }
    
    func getProject(with name: ProjectName?) throws -> [Project] {
        let request = PersistenceController.fetchedProjectRequest
        if let name = name {
            request.predicate = NSPredicate(format: "storedItemName == %@", name)
            return try container.viewContext.fetch(request)
        }
        return []
    }
}

// MARK: - Create Workspace Intent
extension IntentHandler: CreateWorkSpaceIntentHandling {
    func resolveName(for intent: CreateWorkSpaceIntent) async -> INStringResolutionResult {
        if let name = intent.name, name != "No name" {
            return .success(with: name)
        } else {
            return .confirmationRequired(with: intent.name)
        }
    }
    
    func handle(intent: CreateWorkSpaceIntent) async -> CreateWorkSpaceIntentResponse {
        let workspaceName = intent.name ?? "No name"
        
        let newWorkspace = WorkSpace(context: container.viewContext)
        newWorkspace.storedItemName = workspaceName
        newWorkspace.storedItemIconName = "circle"
        
        do {
            try container.viewContext.save()
            return .success(workspace: newWorkspace.intentValue)
        } catch {
            print("Error saving to CoreData: ", error.localizedDescription)
            return .success(workspace: newWorkspace.intentValue)
        }
    }
}

// MARK: - Get Projects Intent
extension IntentHandler: GetProjectsIntentHandling {
    
    func resolveWorkspace(for intent: GetProjectsIntent) async -> WorkspaceIntentResolutionResult {
        handleResolveWorkspaces(self: intent.workspace, project: nil)
    }
    
    func provideWorkspaceOptionsCollection(for intent: GetProjectsIntent) async throws -> INObjectCollection<WorkspaceIntent> {
        availableWorkspaceIntents()
    }
    func handle(intent: GetProjectsIntent) async -> GetProjectsIntentResponse {
        if let workspace = intent.workspace {
            return .success(project: workspace.projects ?? [])
        }
        else {
            return .init(code: .failure, userActivity: nil)
        }
    }
    

}

// MARK: - Get Tables Intent
extension IntentHandler: GetTablesIntentHandling {
    func resolveWorkspace(for intent: GetTablesIntent) async -> WorkspaceIntentResolutionResult {
        handleResolveWorkspaces(self: intent.workspace, project: intent.project)
    }
    
    func resolveProject(for intent: GetTablesIntent) async -> ProjectIntentResolutionResult {
        handleResolveProject(self: intent.project, table: nil)
    }
    
    func defaultWorkspace(for intent: GetTablesIntent) -> WorkspaceIntent? {
        lastUsedWorkspace()
    }
    func provideWorkspaceOptionsCollection(for intent: GetTablesIntent) async throws -> INObjectCollection<WorkspaceIntent> {
        availableWorkspaceIntents()
    }
    
    func provideProjectOptionsCollection(for intent: GetTablesIntent) async throws -> INObjectCollection<ProjectIntent> {
        availableProjectIntents(in: intent.workspace)
    }
    
    func handle(intent: GetTablesIntent) async -> GetTablesIntentResponse {
        let projectID = URL(string: intent.project?.identifier ?? "") ?? defatultProjectID
        if let project = Project.fetchObject(from: projectID, using: container.viewContext) {
            return .success(tables: (project.tables?.allObjects as? [Tables] ?? []).intentValues())
        }
        
        return .init(code: .failure, userActivity: nil)
    }
}

// MARK: - Add Field From Dictionary Intent
extension IntentHandler: AddFieldsFromDictionaryIntentHandling {
    func resolveDictionary(for intent: AddFieldsFromDictionaryIntent) async -> INStringResolutionResult {
        .notRequired()
    }
    
    func resolveTable(for intent: AddFieldsFromDictionaryIntent) async -> TableIntentResolutionResult {
        .notRequired()
    }
    
    func handle(intent: AddFieldsFromDictionaryIntent) async -> AddFieldsFromDictionaryIntentResponse {
        let userActivity = settingsSelectionUserActivity
        userActivity.userInfo?["settings_panel"] = SettingsCathegories.subscribe.rawValue
//        userActivity.requiredUserInfoKeys = ["settings_panel"]

        return .init(code: .continueInApp, userActivity: settingsSelectionUserActivity)
    }
}
//extension IntentHandler: GetTablesIntentHandling {
//    func resolveWorkspace(for intent: GetTablesIntent) async -> INStringResolutionResult {
//        if intent.workspace == "All" { return .success(with: "All") }
//        let workspaces = WorkSpace.searchByName(intent.workspace ?? "", in: container.viewContext)
//        if workspaces.count > 1 {
//            return .disambiguation(with: workspaces.map({ $0.itemName }))
//        } else if workspaces.count == 1 {
//            return .success(with: workspaces[0].itemName)
//        } else {
//            return .needsValue()
//        }
//    }
//
//    func provideWorkspaceOptionsCollection(for intent: GetTablesIntent) async throws -> INObjectCollection<NSString> {
//        INObjectCollection(items: try getWorkSpaces().map { $0.storedItemName as NSString? ?? "No name" })
//    }
//
//    func resolveProjectName(for intent: GetTablesIntent) async -> INStringResolutionResult {
//        if intent.projectName == "All" { return .success(with: "All") }
//
//        let projects = Project.searchByName(
//            intent.projectName ?? "",
//            in: WorkSpace.getID(
//                name: intent.workspace ?? "",
//                in: container.viewContext),
//            in: container.viewContext)
//
//        if projects.count > 1 {
//            return .disambiguation(with: projects.map({ $0.itemName }))
//        } else if projects.count == 1 {
//            return .success(with: projects[0].itemName)
//        } else {
//            return .needsValue()
//        }
//    }
//
//    func provideProjectNameOptionsCollection(for intent: GetTablesIntent) async throws -> INObjectCollection<NSString> {
//
//        var selections = [NSString]()
//
//        let workspaceID = WorkSpace.getID(name: intent.workspace ?? "", in: container.viewContext)
//        let projects = Project.getAllProjects(in: workspaceID, with: container.viewContext)
//
//        selections = projects.map({ $0.itemName as NSString })
//        selections.insert("All", at: 0)
//
//        return INObjectCollection(items: selections)
//    }
//
//    func handle(intent: GetTablesIntent) async -> GetTablesIntentResponse {
//        intent.
//        return .success(tables: [TableIntent(identifier: "Table_Intent", display: intent.projectName ?? "No name")])
//    }
//}
