
# SDK de Microsoft Graph para ObjC


¡Introducción al SDK de Microsoft Graph para ObjectiveC al integrarlo en sus aplicaciones para iOS y MacOS!

## Instalación


### Usar CocoaPods

Puede usar [CocoaPods](https://cocoapods.org/) para mantenerse actualizado con la versión más reciente. Incluya la siguiente línea en su podfile:
  ``` 
   pod 'MSGraphClientSDK'
  ```


### Usar Carthage



También puede optar por usar [Carthage](https://github.com/Carthage/Carthage) para administrar paquetes.



1. Instale Carthage en su Mac con una descarga desde el sitio web o si usa el Homebrew `brew install carthage`.

2. Debe crear un `Cartfile` que enumere la biblioteca MSGraphClientSDK para este proyecto en Github.



```

github "microsoftgraph/msgraph-sdk-objc" "tags/<latest_release_tag>"

```



3. Ejecute `carthage update`. Esto recuperará las dependencias en una carpeta `Carthage/Checkouts` y después, compilará la biblioteca MSGraphClientSDK.

4. En la pestaña de configuración "General" de destino de la aplicación, en la sección "Marcos y bibliotecas vinculadas", arrastre y coloque el `MSGraphClientSDK.framework` desde la carpeta `Carthage/Build` en el disco.

5. En la pestaña de configuración "Fases de compilación" de destino de la aplicación, haga clic en el icono "+" y elija "Nueva fase de ejecución de script". Cree un Script de ejecución en el que especifique el shell (ej.: `/bin/sh`), agregue el siguiente contenido en el área de script debajo del shell:



```sh

/usr/local/bin/carthage copy-frameworks

```



y agregue las rutas de acceso a los marcos que desea usar en "Archivos de entrada", por ejemplo:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphClientSDK.framework

```

Este script funciona alrededor de un [Error de envío de la App Store](http://www.openradar.me/radar?id=6409498411401216) desencadenado por archivos binarios universales y garantiza que los archivos relacionados con bitcode y los dSYMs necesarios se copien al archivar.



Con la información de depuración copiada en el directorio de productos compilados, Xcode podrá resolver símbolos en el seguimiento de pila cuando se detenga en un punto de interrupción. Esto también le permite desplazarse por el código de terceros en el depurador.



Al archivar la aplicación para enviarla a la App Store o TestFlight, Xcode también copiará estos archivos en el subdirectorio dSYMs del paquete `.xcarchive` de la aplicación.



## Requisitos previos

Se debe autenticar cada llamada de red a Microsoft Graph. Por ese motivo, la creación de una instancia de MSHTTPClient toma una instancia del protocolo de MSAuthenticationProvider como parámetro.

Puede crear la instancia de MSAuthenticationProvider de dos maneras:

### Usando [MSGraphMSALAuthProvider](https://github.com/microsoftgraph/msgraph-sdk-objc-auth)

Este repositorio administra los escenarios de autenticación mediante [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)

### Escribiendo su propia implementación de MSAuthenticationProvider

También puede elegir administrar la autenticación por cualquier otro medio que se adapte a sus necesidades. Debe seguir los siguientes pasos para que este SDK pueda interactuar con el mecanismo de autenticación.

1. Luego de integrar el SDK, tendrá que proporcionar la implementación para MSAuthenticationProvider creando un archivo nuevo.

2. En este archivo, escriba una implementación para el siguiente método de MSAuthenticationProvider

```

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

```

Esta implementación debe poder comunicarse con el mecanismo de autenticación para obtener el token de acceso o cualquier error que se haya producido durante el proceso y devolverlo en el bloque de finalización.

## Cómo se usa SDK



Suponiendo que ha realizado los pasos anteriores, ahora tendrá:



1. Un archivo .xcworkspace integrado con el pod de MSGraphClientSDK o un MSGraphClientSDK.framework integrado con el proyecto. 



2. Instancia de una clase que implementa el protocolo MSAuthenticationProvider.



Luego de los pasos anteriores, debe seguir los siguientes pasos:



1. Cree una instancia de MSHTTPClient desde MSClientFactory de la siguiente forma:

```

MSHTTPClient *httpClient = [MSClientFactory createHTTPClientWithAuthenticationProvider:authenticationProvider];

```

2. Configure un objeto de solicitud nativa que puede ser similar al que sigue:

```

NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me"]]];

```

3. Cree un objeto MSURLSessionTask (para nuestro ejemplo un DataTask) con la ayuda de MSHTTPClient de la forma siguiente y llame a execute en él:

```

MSURLSessionDataTask *meDataTask = [httpClient dataTaskWithRequest:urlRequest

completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

// Hacer algo

}];

[meDataTask execute];

```



Y eso es todo. Ahora ha llamado correctamente a un servidor Graph solicitando información sobre el usuario.

## Recursos de uso

* [Procesamiento por lotes](/Docs/Content/Batching.md)
* [Iterador de páginas](/Docs/Tasks/PageIterator.md)
* [Tarea de carga de archivos de gran tamaño](/Docs/Tasks/LargeFileUpload.md)
