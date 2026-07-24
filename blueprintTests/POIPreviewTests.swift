//
//  POIPreviewTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

struct POIPreviewTests {

    @Test func previewProvidesSamplePOI() {
        let poi = POI.preview()

        #expect(poi.id == "preview-1")
        #expect(poi.name == "Museu do Ipiranga")
        #expect(poi.city == "São Paulo")
    }
}
