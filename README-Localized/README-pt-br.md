
# SDK do Microsoft Graph para ObjC


Comece a usar o SDK do Microsoft Graph para ObjectiveC integrando-o aos seus aplicativos iOS e MacOS!

## Instalação


### Usando o CocoaPods

Você pode usar o [CocoaPods](https://cocoapods.org/) para se manter atualizado com a versão mais recente. Inclua a seguinte linha no seu podfile:
  ``` 
   pod 'MSGraphClientSDK'
  ```


### Usando o Carthage



Você também pode optar por usar o [Carthage](https://github.com/Carthage/Carthage) no gerenciamento de pacotes.



1. Instale o Carthage no Mac baixando do site ou, se estiver usando o Homebrew, use `brew install carthage`.

2. Você deve criar um `Cartfile` que lista a biblioteca MSGraphClientSDK desse projeto no Github.



```

github "microsoftgraph/msgraph-sdk-objc" "tags/<latest\_release\_tag>"

```



3. Execute `carthage update`. Este comando busca dependências na pasta `Carthage/Checkouts` e cria a biblioteca MSGraphClientSDK.

4. Na guia das configurações "Gerais" do destino do aplicativo, na seção "Estruturas e Bibliotecas Vinculadas", arraste e solte o `MSGraphClientSDK.framework` da pasta `Carthage/Build` no disco.

5. Na guia de configurações "Fases do Build" do destino do aplicativo, clique no ícone "+" e escolha "Nova Fase de Script de Execução". Crie um Script de Execução no qual você especifica o shell (por exemplo, `/bin/sh`); adicione o seguinte conteúdo à área de script abaixo do shell:



```sh

/usr/local/bin/carthage copy-frameworks

```



e adicione os caminhos para as estruturas que você deseja usar em "arquivos de entrada", como, por exemplo:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphClientSDK.framework

```

Este script funciona em torno de um [Bug de envio da App Store](http://www.openradar.me/radar?id=6409498411401216) acionado por binários universais e garante que os arquivos necessários relacionados a BitCode e dSYMs sejam copiados durante o arquivamento.



Com as informações de depuração copiadas no diretório de produtos criados, o Xcode poderá simbolizar o rastreamento da pilha sempre que você parar em um ponto de interrupção. Isso também permitirá que você percorra o código de terceiros no depurador.



Ao arquivar o aplicativo para envio para a App Store ou TestFlight, o Xcode também copia esses arquivos no subdiretório dSYMs do pacote `.xcarchive` do aplicativo.



## Pré-requisitos

Cada chamada de rede do Microsoft Graph deve ser autenticada. Para isso, a criação de uma instância de MSHTTPClient usa como parâmetro a instância do protocolo MSAuthenticationProvider.

Você pode criar a instância MSAuthenticationProvider de duas maneiras:

### Usando [MSGraphMSALAuthProvider](https://github.com/microsoftgraph/msgraph-sdk-objc-auth)

Esse repositório lida com os cenários de autenticação por meio do [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)

### Escrevendo sua própria implementação do MSAuthenticationProvider

Você também pode optar por lidar com a autenticação por qualquer meio que atenda às suas necessidades. É necessário seguir as etapas abaixo para que este SDK possa interagir com o mecanismo de autenticação.

1. Após integrar o SDK, você precisará fornecer a implementação ao MSAuthenticationProvider criando um novo arquivo.

2. Neste arquivo, escreva uma implementação para o método abaixo do MSAuthenticationProvider

```

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

```

Essa implementação deve ser capaz de se comunicar com o mecanismo de autenticação para obter o token de acesso ou qualquer erro ocorrido durante o processo e devolvê-lo no bloco de conclusão.

## Como usar o SDK



Supondo que você passou pelas etapas acima, agora você terá:



1. Um arquivo .xcworkspace integrado ao MSGraphClientSDK Pod ou o MSGraphClientSDK.framework integrado no seu projeto. 



2. Instância de uma classe implementando o protocolo MSAuthenticationProvider.



Depois de realizar as etapas acima, você precisa fazer o seguinte:



1. Crie uma instância de MSHTTPClient do MSClientFactory da seguinte maneira:

```

MSHTTPClient *httpClient = [MSClientFactory createHTTPClientWithAuthenticationProvider:authenticationProvider];

```

2. Configure um objeto de solicitação nativo, que pode ser parecido com o seguinte:

```

NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me"]]];

```

3. Crie um objeto MSURLSessionTask (no caso do nosso exemplo, uma DataTask) com a ajuda do MSHTTPClient da seguinte maneira e chame a execução dele:

```

MSURLSessionDataTask *meDataTask = [httpClient dataTaskWithRequest:urlRequest

completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

//Execute algo

}];

[meDataTask execute];

```



Pronto. Você já fez uma chamada com êxito para o servidor de gráfico solicitando informações sobre o usuário.

## Recursos de uso

* [Envio em lote](/Docs/Content/Batching.md)
* [Iterador de página](/Docs/Tasks/PageIterator.md)
* [Tarefa de carregar arquivos grandes](/Docs/Tasks/LargeFileUpload.md)
