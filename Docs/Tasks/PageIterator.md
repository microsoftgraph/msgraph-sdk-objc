# PageIterator

This task enables the consumers of the SDK to iterate through paged collections in a simplified manner.

To understand the objectives and requirements for this feature in more detail, please refer [PageIterator](https://github.com/microsoftgraph/msgraph-sdk-design/blob/master/tasks/PageIteratorTask.md).

## Usage

### Creating the client instance

Refer [this part](https://github.com/microsoftgraph/msgraph-sdk-objc#how-to-use-sdk) of Readme file and follow the steps to create an HTTP Client configured with authentication provider.

### Using the MSPageIterator class
    //Create a request for the API which will have paged collection response. For example:/me/messages
    NSMutableURLRequest *messageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[MSGraphBaseURL stringByAppendingString:@"/me/messages?$top=10"]]];

    //Create a data task to get the initial response
    MSURLSessionDataTask *dataTask = [httpClient dataTaskWithRequest:messageRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            __block int itemCount = 0;
            //If there is no error, use MSPageIterator instance to perform intra-page iteration and then onwards inter-page iteration.
            MSPageIterator *pageIterator = [[MSPageIterator alloc] initWithData:data client:httpClient andIteratorBlock:^(NSDictionary *itemDictionary, BOOL *stop) {
                //The itemDictionary in callback block corresponds to individual message in the list.
                if(itemCount == 21){
                    //You can stop the iteration in below fashion.
                    *stop = TRUE;
                }
                itemCount++;
            }];
            //Start the iteration
            [pageIterator iterate];
        }
    }];
    [dataTask execute];
```
