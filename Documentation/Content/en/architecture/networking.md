---
title: Networking
summary: How I kept HTTP behind NetworkClient and inside Repositories.
order: 4
---
# Networking

*How I wired Geoapify without leaking HTTP into ViewModels.*

Discover loads places from **Geoapify** over HTTPS. In this repo, HTTP details live in the Data layer plus a small Swift Package.

## What I built

| Piece | Location | Job |
|---|---|---|
| `NetworkClient` | `Packages/Networking` | Execute a `URLRequest`, return `Data` |
| `URLSessionNetworkClient` | same | Production implementation + status check |
| `NetworkError` | same | Transport failures (bad URL, HTTP 4xx/5xx) |
| Repositories | `Data/Repositories/` | Build URL, call client, decode DTO, map to Domain |
| DTOs + mappers | `Data/DTO/` | Geoapify JSON shape |

```swift
public protocol NetworkClient: Sendable {
  func data(for request: URLRequest) async throws -> Data
}
```

Repositories receive `NetworkClient` in `init`. ViewModels and UseCases never see HTTP.

## How a fetch works

Inside `POIRepository`:

1. Check cache (first page only)
2. Build `URLComponents` for `https://api.geoapify.com/v2/places`
3. Add query items (categories, circle filter, limit, offset, apiKey)
4. `let data = try await client.data(for: request)`
5. `JSONDecoder` → `GeoapifyResponseDTO`
6. Mapper → `[POI]`

`GeocodingRepository` and `PlaceDetailsRepository` repeat steps 2–5 with different paths. Same pattern, three copies.

### What I did

Thin `NetworkClient` package. Everything Geoapify-specific (URL, decode, map) inside each Repository.

### Why (then)

I wanted one mockable seam for tests (`NetworkClient` or repository protocol) without building a full networking framework. For three similar endpoints, inline URL building felt readable.

### What I'd reconsider

I have done projects with `Endpoint` enums, request builders, and separate API error types. That pays off with many endpoints, shared auth headers, retries, and interceptors. Discover does not need that yet; the duplication is the main thing I would fix next.

## Could I split into single responsibilities?

In larger projects you often see:

| Type | Typical job |
|---|---|
| `Endpoint` enum | Path, HTTP method, default headers |
| `URLBuilder` / `RequestBuilder` | Endpoint + params → `URLRequest` |
| `NetworkClient` | Execute request, validate HTTP status |
| `NetworkError` | Transport (timeout, no connection, 500) |
| `APIError` | Server body or schema mismatch |
| `ErrorMapper` | `NetworkError` → `AppError` |

I did not do that here. Not because SRP is wrong, but because this chapter was about "HTTP behind a protocol + DTOs in Data," not about teaching a reusable network stack.

## Errors (incomplete on purpose)

| Enum | Layer | Used for |
|---|---|---|
| `NetworkError` | `Packages/Networking` | Invalid URL, bad HTTP response, decode in repositories |
| `AppError` | Domain | What the UI shows |

Repositories throw `NetworkError`. ViewModels catch **any** error and set `UIState.failure(.networking)`. I never added `NetworkError` → `AppError` mapping or Geoapify-specific API errors. One generic error screen was enough for the study scope.

### What I'd reconsider

Before shipping for real users I would map at the Repository boundary so the UI can distinguish offline vs bad data vs server error.

## API key

`Config.xcconfig` → build settings → `Info.plist` → `Secrets.geoapifyAPIKey`. Repositories read it in `POIDependencies`.

Do not hardcode keys or commit `Config.xcconfig`.

## DTOs and mappers

| Piece | Location | Role |
|---|---|---|
| `GeoapifyResponseDTO` | `Data/DTO/` | Matches API JSON |
| `GeoapifyMapper` | `Data/DTO/` | DTO → Domain `POI` |
| `POI` | `Domain/Entities/` | What the app understands |

## What a split could look like later

Not implemented, but a natural next step in this codebase:

```
GeoapifyEndpoint          → path + method
GeoapifyRequestBuilder    → Endpoint + apiKey + query → URLRequest
NetworkClient             → unchanged
POIRepository             → builder + decode + map + cache
NetworkErrorMapper        → NetworkError → AppError
```

## Read next

- [Repositories & Services](/architecture/repositories-and-services/)
- [Dependency Injection](/architecture/dependency-injection/)
