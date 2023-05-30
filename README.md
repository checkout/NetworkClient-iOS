# CheckoutNetwork-iOS

SPM distributed shared approach to networking for iOS projects.

Project does not handle any credentials or security, it simply acts as a passthrough for the request, encouraging some similar practices to be implemented for a consistent approach to networking.

***

## Features of component

#### Encourages a single source of truth for endpoints

Consumer should declare an enum conforming to `NetworkPath`, which will enable a single source of truth for endpoints, clear URL formatting and a consistent approach across the project

#### Abstracts complex details inside RequestConfiguration Model

This allows consumer application to not have to declare their own MIME types, handle query parameters, headers or other details differently each time. By requesting the same model to be provided when running, it enforces a consistent, reviewable approach, whilst building in the parsing mechanism to integrate these details in the final request

#### Baked in testing support

Target `CheckoutNetworkFakeClient` can be imported in unit tests to encourage easy and convenient testability of the behaviour.

#### Abstract response handling

Simply receive an error or a Decoded object. No need to validate error, result status on different calls, ensuring a consistent communication in sync with the Checkout.com backend standards.
