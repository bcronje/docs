# Using our API

The Enclave REST API lets you automate your network; anything you can do via the [Enclave Portal](https://portal.enclave.io), you can also do via our APIs.

All APIs are accessed over HTTPS at [https://api.enclave.io](https://api.enclave.io), and generally follow 'standard' REST patterns. We use the following HTTP Methods:

| Method | Usage                                                                                         |
| :----- | :-------------------------------------------------------------------------------------------- |
| GET    | Retrieve existing data. GET calls are idempotent (no data is ever modified by a GET request). |
| POST   | Create a new entity in your organisation. In most cases, returns the created entity.          |
| PATCH  | Modify an existing entity in your organisation. Returns the entity after any modifications.   |
| PUT    | Mutate the state of one or more entities (e.g. enable, disable)                               |
| DELETE | Remove one or more entities from your organisation                                            |

## Swagger/OpenAPI

We provide a complete Swagger/OpenAPI definition file at [https://api.enclave.io/swagger/v1/swagger.json](https://api.enclave.io/swagger/v1/swagger.json); you can use 
your favourite OpenAPI code generator (such as [swagger-codegen](https://swagger.io/tools/swagger-codegen/)) to create a client in your preferred language.

The root URL of our API server ([https://api.enclave.io/](https://api.enclave.io)) hosts a basic Swagger UI that you can use to view all our endpoints,
and test them out.

## Authentication

There are almost no unauthenticated APIs in Enclave's REST API; in most cases, you will need to authenticate with our APIs.

Authentication is achieved through the use of a **Personal Access Token**, that is passed as a standard oauth `Authorisation: Bearer` token in the header.

You can create access tokens in your [account page in the portal](https://portal.enclave.io/account). These tokens
are 63-character alpha-numeric strings, and are secrets that should be protected in the same way as other network secrets you possess.

![Location of Personal Access Tokens in your account page](/images/api/pat-location.png)

> Created tokens currently have access to all of the Enclave organisations that your account has access to in the portal. In future we will allow tokens to be restricted
> to a specific organisation.

As an example, you can use `curl` to authenticate (and get the list of organisations you have access to):

```bash
$ curl --oauth2-bearer <token> https://api.enclave.io/account/orgs
{
  "orgs": [
    {
      "orgId": "xxxxxxxxxx",
      "orgName": "Demo Organisation",
      "role": "Owner"
    }
  ]
}
```

> In subsequent examples we're going to use `$token` in place of a full token. On linux, you can create this variable in your terminal:
> 
> ```
> $ token=<token>
> ```

## Organisation ID

Most of the operations you will want to perform against the Enclave API will happen in the context of an **organisation**. All the entities you can manipulate
via the API are attached to an organisation, so you will need to pass an Organisation ID to these APIs.

> The ID of your organisation can be found in the [settings page](https://portal.enclave.io/my/settings), but can also be found
> in the portal URL (e.g. `https://portal.enclave.io/org/<orgId>/systems`).
> 
> ![Organisation ID location in Organisation Settings](/images/api/orgid-location.png)
>
> Organisation IDs are **not** secret, and can freely be shared. Only users with access to that organisation will be able to invoke APIs against it.

Here's an example of getting the list of systems in your organisation:
```bash
$ curl --oauth2-bearer $token https://api.enclave.io/org/<orgId>/systems
{
  "metadata": {
    "total": 1,
    "firstPage": 0,
    "prevPage": null,
    "lastPage": 0,
    "nextPage": null
  },
  "links": {
    "first": "https://api.enclave.io/org/<orgId>/systems",
    "prev": null,
    "next": null,
    "last": "https://api.enclave.io/org/<orgId>/systems"
  },
  "items": [
    {
      "systemId": "ABC",
      "description": "John's Laptop",
      "state": "Connected",
      "customDns": [],
      "lastSeen": "2021-03-31T11:31:44.3846701Z",
      "enrolledAt": "2021-03-31T10:55:41.291Z",
      "enrolmentKeyId": 1,
      "enrolmentKeyDescription": "Workstations",
      "isEnabled": true,
      "connectedFrom": "X.X.X.X",
      "hostname": "JOHN-LAPTOP",
      "platformType": "Windows",
      "osVersion": "Microsoft Windows 10 Pro (10.0.19041)",
      "enclaveVersion": "2021.3.24.0",
      "tags": [
        {
          "tag": "quickstart"
        }
      ]
    }
  ]
}
```

> In subsequent examples, we'll refer to our organisation ID with `$orgId`, much as we did with `$token`.

## Parameters

For `GET` requests, all additional parameters not already specified in the URL can be passed as query string parameters:

```bash
$ curl --oauth2-bearer $token https://api.enclave.io/org/$orgId/systems?search=Jane
```

In this example, we're adding the additional search parameter to filter the retrieved list is passed in the query string.

For `POST`, `PATCH`, `PUT` and `DELETE` requests, parameters not included in the URL should be provided as JSON in the request body,
with a `Content-Type` of `application/json`.

```bash
$ curl --oauth2-bearer $token \
       -H 'Content-Type: application/json' \
       -d  '{"description": "My New Key"}' \
       https://api.enclave.io/org/$orgId/enrolment-keys
```

The above example creates a new Enrolment Key called "My New Key", and returns the created key.

## Timestamps

All date/time values returned from our API are formatted in ISO8601 format (e.g. `2021-03-31T11:31:44.3846701Z`), and always in the UTC timezone.

## User-Agent Header

All requests to the Enclave API must provide a `User-Agent` header (your requests will fail without one). We ask that you specify a `User-Agent` 
describing your application, to help identify it. Here's an example with curl:

```bash
$ curl -A "my-app-integration" --oauth2-bearer $token https://api.enclave.io/org/$orgId/systems?search=Jane
```

## API Errors

Errors from the API are returned using the standard Problem Details format ([RFC 7807](https://tools.ietf.org/html/rfc7807)).

We try to make the information returned in these errors as useful as possible:

```bash
$ curl --oauth2-bearer $token -i https://api.enclave.io/org/$orgId/systems/NOTASYSTEM
HTTP/2 404
server: nginx
date: Thu, 01 Apr 2021 14:50:15 GMT
content-type: application/problem+json; charset=utf-8
cache-control: no-cache, no-store, must-revalidate
pragma: no-cache
expires: 0

{
  "type": "https://api.enclave.io/problems/type/system-not-found",
  "title": "System cannot be found",
  "status": 404,
  "detail": "System with Enclave identity NOTASYSTEM does not exist, or your access rights do not allow access to it.",
  "instance": "https://api.enclave.io/problems/instance/7a206c0eb9208c4caab0975333ce47eb",
  "traceId": "00-7a206c0eb9208c4caab0975333ce47eb-3aa520cfe7bed641-00"
}
```

> Most error responses include a `traceId` value. You can include this value in support discussions to help us narrow down your problem.
