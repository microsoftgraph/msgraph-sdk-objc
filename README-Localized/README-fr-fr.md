
# Kit de développement logiciel Microsoft Graph pour ObjC


Commencez à utiliser le kit de développement logiciel (SDK) Microsoft Graph pour ObjectiveC en l’intégrant dans vos applications iOS et MacOS !

## Installation


### Utilisation de CocoaPods

Vous pouvez utiliser [CocoaPods](https://cocoapods.org/) pour rester informé sur la dernière version. Incluez la ligne suivante dans votre podfile :
  ``` 
   pod 'MSGraphClientSDK'
  ```


### Utilisation de Carthage



Vous pouvez également choisir de recourir à [Carthage](https://github.com/Carthage/Carthage) pour la gestion des packages.



1. Installez Carthage sur votre Mac à l’aide d’un téléchargement à partir de leur site web, ou si vous utilisez Homebrew `brew install Carthage`.

2. Vous devez créer un `cartfile` qui répertorie la bibliothèque MSGraphClientSDK pour ce projet sur GitHub.



```

github "microsoftgraph/msgraph-sdk-objc" "tags/<latest\_release\_tag>"

```



3. Exécutez la `mise à jour carthage`. Elle récupère les dépendances dans un dossier `Carthage/Checkouts`, puis génère la bibliothèque MSGraphClientSDK.

4. Sous l’onglet de Paramètres « Général » de votre cible d'application, dans la section « Bibliothèques et infrastructures liées », faites glisser et déposez le `MSGraphClientSDK.framework` à partir du dossier `Carthage/Build` sur le disque.

5. Dans l’onglet de Paramètres « Phases de Build » de la cible d'application, cliquez sur l’icône « + », puis sélectionnez « Nouvelle phase d'exécution du script ». Créez un Script d'exécution dans lequel vous spécifiez votre interpréteur de commandes (par exemple, `/bin/sh`), ajoutez le contenu suivant à la zone de script sous l’interpréteur :



```sh

/usr/local/bin/carthage copy-frameworks

```



et ajoutez les chemins d’accès aux infrastructures que vous voulez utiliser sous « Fichiers d’entrée », par ex. :



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphClientSDK.framework

```

Ce script se consacre au [bogue de soumission App Store,](http://www.openradar.me/radar?id=6409498411401216) déclenché par des fichiers binaires universels et vous permet de vous assurer que les fichiers liés au bitcode et les dSYMs nécessaires sont copiés lors de l’archivage.



Une fois les informations de débogage copiées dans l’annuaire des produits built, Xcode pourra générer des symboles d'arborescence des appels de procédure chaque fois que vous vous arrêtez à un point d’arrêt. Cela vous permet également de parcourir le code tiers dans le débogueur.



Lors de l’archivage de votre application à des fins de soumission vers l’App Store ou le TestFlight, Xcode copiera également ces fichiers dans le sous-répertoire dSYMs du groupe `.xcarchive` de l'application.



## Conditions préalables

Chaque appel réseau à Microsoft Graph doit être authentifié. À cet effet, la création d’une instance de MSHTTPClient prend l’instance d’un protocole MSAuthenticationProvider comme paramètre.

Vous pouvez créer l’instance MSAuthenticationProvider à l’aide des deux méthodes suivantes :

### Utilisation de [MSGraphMSALAuthProvider](https://github.com/microsoftgraph/msgraph-sdk-objc-auth)

Ce repo gère les scénarios d’authentification via [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)

### En écrivant votre propre implémentation de MSAuthenticationProvider

Vous pouvez également choisir de gérer l’authentification à l’aide de n’importe quel moyen répondant à vos besoins. Vous devez suivre les étapes ci-dessous pour que ce SDK puisse interagir avec votre mécanisme d’authentification.

1. Une fois le kit de développement logiciel (SDK) intégré, vous devez fournir l’implémentation pour MSAuthenticationProvider en créant un nouveau fichier.

2. Dans ce fichier, écrivez une implémentation pour la méthode MSAuthenticationProvider

```

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

```

Cette implémentation doit être en mesure de parler à votre mécanisme d’authentification afin d’obtenir le jeton d’accès ou toute erreur qui s’est produite pendant le processus et de le renvoyer dans le bloc d’achèvement.

## Utiliser le kit de développement logiciel



En supposant que vous avez suivi les étapes ci-dessus, vous disposez désormais des éléments suivants :



1. Fichier. xcworkspace intégré avec pod MSGraphClientSDK ou MSGraphClientSDK.framework intégré à votre projet. 



2. Instance d’une classe implémentant le protocole MSAuthenticationProvider.



Une fois les étapes précédentes effectuées, vous devez suivre les étapes ci-dessous :



1. Créez une instance de MSHTTPClient à partir de MSClientFactory en procédant de la manière suivante :

```

MSHTTPClient *httpClient = [MSClientFactory createHTTPClientWithAuthenticationProvider:authenticationProvider];

```

2. Configurez un objet de demande native qui peut ressembler à ceci :

```

NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me"]]];

```

3. Créez une MSURLSessionTask (dans notre exemple, un DataTask) avec l’aide d’MSHTTPClient comme ci-dessous et appelez exécuter sur celle-ci :

```

MSURLSessionDataTask *meDataTask = [httpClient dataTaskWithRequest:urlRequest

completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

//Do something

}];

[meDataTask execute];

```



Et voilà. Vous avez désormais créé un appel à Graph Server qui demande des informations sur l’utilisateur.

## Ressources d’utilisation

* [Traitement par lots](/Docs/Content/Batching.md)
* [Itérateur de page](/Docs/Tasks/PageIterator.md)
* [Tâche de chargement d’un fichier volumineux](/Docs/Tasks/LargeFileUpload.md)
