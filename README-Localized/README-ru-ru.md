
# Пакет SDK Microsoft Graph для ObjC


Чтобы начать работу с пакетом SDK Microsoft Graph для ObjectiveC, интегрируйте его в приложения iOS и MacOS!

## Установка


### Использование CocoaPods

Вы можете использовать [CocoaPods](https://cocoapods.org/), чтобы обеспечить актуальность установленной версии. Включите в свой профиль следующую строку:
  ``` 
   pod 'MSGraphClientSDK'
  ```


### Использование Carthage



Вы также можете использовать [Carthage](https://github.com/Carthage/Carthage) для управления пакетами.



1. Чтобы установить Carthage на компьютере Mac, скачайте программу с официального веб-сайта, а если используется Homebrew, выполните команду `brew install carthage`.

2. На сайте Github необходимо создать для этого проекта файл `Cartfile`, в котором указана библиотека MSGraphClientSDK.



```

github "microsoftgraph/msgraph-sdk-objc" "tags/<тег\_новейшего\_выпуска>"

```



3. Выполните команду `carthage update`. Эта команда извлечет зависимости в папку `Carthage/Checkouts`, а затем выполнит сборку библиотеки MSGraphClientSDK.

4. На вкладке настроек "Общие" для целевого приложения найдите раздел "Связанные платформы и библиотеки" и перетащите файл `MSGraphClientSDK.framework` из папки `Carthage/Build` на диске.

5. На вкладке настроек "Этапы сборки" для целевого приложения щелкните значок "+" и выберите "Новый этап сценария выполнения". Создайте сценарий запуска, в котором указана оболочка (пример: `/bin/sh`), и добавьте следующий текст в область сценария под оболочкой:



```sh

/usr/local/bin/carthage copy-frameworks

```



Затем добавьте пути к платформам, которые требуется использовать, в раздел "Входные файлы", например:



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphClientSDK.framework

```

Этот сценарий помогает избежать [ошибки отправки в App Store](http://www.openradar.me/radar?id=6409498411401216), которую вызывают универсальные двоичные файлы, и обеспечивает копирование необходимых файлов, связанных с Bitcode, и dSYM при архивации.



После копирования отладочной информации в каталог собранных продуктов Xcode сможет выражать символами трассировку стека при достижении точек останова. Это также даст вам возможность пошагового выполнения стороннего кода в отладчике.



При архивации приложения для отправки в App Store или TestFlight среда Xcode также скопирует эти файлы в подкаталог dSYMs пакета `.xcarchive` для вашего приложения.



## Предварительные требования

Каждый сетевой вызов к Microsoft Graph должен пройти проверку подлинности. Для этого при создании экземпляра MSHTTPClient в качестве параметра используется экземпляр протокола MSAuthenticationProvider.

Вы можете создать экземпляр MSAuthenticationProvider двумя способами:

### Использование [MSGraphMSALAuthProvider](https://github.com/microsoftgraph/msgraph-sdk-objc-auth)

Этот репозиторий обрабатывает сценарии проверки подлинности с помощью [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc)

### Создание собственной реализации MSAuthenticationProvider

Вы также можете обрабатывать проверку подлинности любыми способами, подходящими вашим потребностям. Чтобы пакет SDK мог взаимодействовать с механизмом проверки подлинности, требуется выполнить действия, указанные ниже.

1. После интеграции пакета SDK потребуется обеспечить реализацию для MSAuthenticationProvider, создав новый файл.

2. В этом файле создайте реализацию для указанного ниже метода MSAuthenticationProvider

```

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

```

Эта реализация должна поддерживать механизм проверки подлинности, чтобы получать маркер доступа или любые ошибки, возникающие в ходе процесса, и возвращать их в блок завершения.

## Способ использования пакета SDK



С учетом выполнения предыдущих действий у вас имеются следующие компоненты:



1. Файл .xcworkspace, интегрированный с объектом pod MSGraphClientSDK или MSGraphClientSDK.framework, встроенным в ваш проект. 



2. Экземпляр класса, реализующего протокол MSAuthenticationProvider.



После вышеуказанных действий требуется выполнить следующее:



1. Создайте экземпляр MSHTTPClient из MSClientFactory указанным ниже образом:

```

MSHTTPClient *httpClient = \[MSClientFactory createHTTPClientWithAuthenticationProvider:authenticationProvider];

```

2. Настройте собственный объект запроса, который может выглядеть примерно так:

```

NSMutableURLRequest *urlRequest = \[NSMutableURLRequest requestWithURL:\[NSURL URLWithString:\[MSGraphBaseURL stringByAppendingString:@"/me"]]];

```

3. Создайте объект MSURLSessionTask (в нашем примере — DataTask) с помощью MSHTTPClient указанным ниже способом и вызовите для него команду исполнения:

```

MSURLSessionDataTask *meDataTask = \[httpClient dataTaskWithRequest:urlRequest

completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

//Какое-то действие

}];

\[meDataTask execute];

```



Вот и все. Вы успешно выполнили вызов к серверу Graph с запросом сведений о пользователе.

## Ресурсы по применению

* [Пакетная обработка](/Docs/Content/Batching.md)
* [Итератор страниц](/Docs/Tasks/PageIterator.md)
* [Задача отправки больших файлов](/Docs/Tasks/LargeFileUpload.md)
