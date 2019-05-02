# Large File Upload Task - Uploading large files to OneDrive.

This task can be used for of onedrive's [Upload large files with an upload session](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/driveitem_createuploadsession) feature.

## Creating the client instance

Refer [this part](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk) of Readme file and follow the steps to create an HTTP Client configured with authentication provider.

## Uploading the file

 Once you have an MSHTTPClient instance you just need to use `MSGraphOneDriveLargeFileUploadTask` class in below fashion to successfully upload the file:
 ```
  //Get file url
    NSURL *fileURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"LargeFileUploadResource" ofType:@".bmp"]];
    NSError *fileReadError;
    //Create file data
    NSData *fileData = [NSData dataWithContentsOfFile:[fileURL absoluteString] options:kNilOptions error:&fileReadError];
    if(!fileReadError)
    {
        //Create an MSGraphOneDriveLargeFileUploadTask.
        [MSGraphOneDriveLargeFileUploadTask createOneDriveLargeFileUploadTaskWithHTTPClient:httpClient fileData:fileData fileName:@"LargeFile" filePath:@"Documents" andChunkSize:5*1024*1024 withCompletion:^(MSGraphOneDriveLargeFileUploadTask *fileUploadTask, NSData *data, NSURLResponse *response, NSError *error) {
            if(error)
            {
                //Handle any error which might have occurred during upload session creation
                NSLog(@"There was some error while creating upload session %@",error);
            }
            else if([(NSHTTPURLResponse *)response statusCode] == 200 && fileUploadTask)
            {
                //Use successfully created fileUploadTask to upload the file.
                [fileUploadTask uploadWithCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if(!error)
                    {
                        NSLog(@"Response from server %@",[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                    }
                }];
            }
        }];
    }
 ```

