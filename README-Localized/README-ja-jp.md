
# ObjC 用 Microsoft Graph SDK


ObjectiveC 向けの Microsoft Graph SDK を iOS および MacOS アプリケーションに統合して使用を開始しましょう !

## インストール


### CocoaPods を使う

[CocoaPods](https://cocoapods.org/) を使用すれば、最新バージョンを使用して最新の状態に保つことができます。ポッドファイルに次の行を含めます:
  ``` 
   pod 'MSGraphClientSDK'
  ```


### Carthage を使う



パッケージ管理に [Carthage](https://github.com/Carthage/Carthage) を使用することもできます。



1. Mac に Carthage をインストールするには、Web サイトからダウンロードするか、Homebrew [ `brew install carthage` を使用します。

2. Github でこのプロジェクトの MSGraphClientSDK ライブラリを一覧表示する `Cartfile` を作成する必要があります。



```

github "microsoftgraph/msgraph-sdk-objc" "tags/<latest\_release\_tag>"

```



3. `carthage update` を実行します。このコマンドは依存性を取り出して `Carthage/Checkouts` フォルダーに入れ、MSGraphClientSDK ライブラリをビルドします。

4. アプリケーション ターゲットの [全般] 設定タブの [リンクされたフレームワークとライブラリ] セクションで、`MSGraphClientSDK.framework` をディスク上の `Carthage/Build` フォルダーからドラッグアンドドロップします。

5. アプリケーション ターゲットの [ビルド フェーズ] 設定タブで、[+] アイコンをクリックして [新規スクリプト実行フェーズ] を選択します。シェル (例: `/bin/sh`) を指定して実行スクリプトを作成し、シェルの下のスクリプト領域に次のコンテンツを追加します。



```sh

/usr/local/bin/carthage copy-frameworks

```



使用するフレームワークへのパスを “入力ファイル” の下に追加します。例:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphClientSDK.framework

```

このスクリプトは、ユニバーサル バイナリによってトリガーされる [App Store 提出バグ](http://www.openradar.me/radar?id=6409498411401216)を回避し、必要なビットコード関連ファイルおよび dSYM がアーカイブ時に確実にコピーされるようにします。



デバッグ情報が構築された製品ディレクトリにコピーされると、Xcode はブレークポイントで停止するたびにスタック トレースを記号化できます。これにより、デバッガーでサードパーティのコードをステップ実行することもできます。



App Store または TestFlight に提出するためにアプリケーションをアーカイブする場合、Xcode はこれらのファイルをアプリケーションの `.xcarchive` バンドルの dSYMs サブディレクトリにもコピーします。



## 前提条件

Microsoft Graph への各ネットワーク呼び出しは認証される必要があります。そのため、MSHTTPClient のインスタンスの作成は、MSAuthenticationProvider プロトコルのインスタンスをパラメーターとして受け取ります。

MSAuthenticationProvider インスタンスは、2 つの方法で作成できます。

### [MSGraphMSALAuthProvider](https://github.com/microsoftgraph/msgraph-sdk-objc-auth) を使用する

このリポジトリは、[MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) を介して認証シナリオを処理します

### MSAlauthenticationProvider の独自の実装を記述する

自身のニーズに合った手段で認証を処理することもできます。この SDK が認証メカニズムを操作できるように、以下の手順に従う必要があります。

1. SDK を統合した後、新しいファイルを作成して MSAlauthenticationProvider の実装を提供する必要があります。

2. このファイルに、MSAlauthenticationProvider の以下のメソッドの実装を記述します

```

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

```

この実装は、アクセス トークンまたはプロセス中に発生したエラーを取得して完了ブロックで返すために、認証メカニズムと通信できる必要があります。

## SDK の使用方法



上記の手順を完了したと仮定すると、以下が揃っているはずです。



1. MSGraphClientSDK ポッドと統合された .xcworkspace ファイルまたはプロジェクトに統合された MSGraphClientSDK.framework。 



2. MSAuthenticationProvider プロトコルを実装するクラスのインスタンス。



上記の手順の後に、次の手順を実行する必要があります。



1. 以下の方法で、MSClientFactory から MSHTTPClient のインスタンスを作成します。

```

MSHTTPClient *httpClient = [MSClientFactory createHTTPClientWithAuthenticationProvider:authenticationProvider];

```

2. 以下のようなネイティブ要求オブジェクトを設定します。

```

NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me"]]];

```

3. MSHTTPClient の助けを借りて MSURLSessionTask (この例の場合は DataTask) オブジェクトを以下の方法で作成し、その上で execute を呼び出します。

```

MSURLSessionDataTask *meDataTask = [httpClient dataTaskWithRequest:urlRequest

completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

//何かを実行します

}];

[meDataTask execute];

```



これで完了です。これで、ユーザーに関する情報を要求するグラフ サーバーへの呼び出しが正常に行われました。

## 使用方法リソース

* [バッチ処理](/Docs/Content/Batching.md)
* [ページの反復子](/Docs/Tasks/PageIterator.md)
* [大容量ファイルのアップロード タスク](/Docs/Tasks/LargeFileUpload.md)
