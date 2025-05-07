// swift-tools-version: 5.10

import PackageDescription

/// Swift Package Conversion Notes:
/// * Added all the same resources and updated multiple call sites to load from NSBundle to SWIFTPM_MODULE_BUNDLE
/// * Tests require UIKit and take a long time to run
/// * Custom build.sh script to make it easy to run tests from command line
///

let package = Package(
    name: "GeoPackage",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13), .macOS(.v12)
    ],
    products: [
        .library(
            name: "GeoPackage",
            targets: ["GeoPackage"])
    ],
    dependencies: [
        .package(url: "https://github.com/ngageoint/ogc-api-features-json-ios", from: "5.0.0"),
        .package(url: "https://github.com/ngageoint/simple-features-wkb-ios", from: "5.0.0"),
        .package(url: "https://github.com/ngageoint/simple-features-wkt-ios", from: "3.0.0"),
        .package(url: "https://github.com/ngageoint/simple-features-proj-ios", from: "7.0.0"),
        .package(url: "https://github.com/ngageoint/tiff-ios", from: "5.0.0"),
        .package(url: "https://github.com/ngageoint/color-ios", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "GeoPackage",
            dependencies: [
                .product(name: "OGC_APIFeaturesJSON", package: "ogc-api-features-json-ios"),
                .product(name: "SimpleFeaturesWKB", package: "simple-features-wkb-ios"),
                .product(name: "SimpleFeaturesWKT", package: "simple-features-wkt-ios"),
                .product(name: "SimpleFeaturesProjections", package: "simple-features-proj-ios"),
                .product(name: "TIFF", package: "tiff-ios"),
                .product(name: "Color", package: "color-ios"),
            ],
            path: "geopackage-ios",
            resources: [
                .copy("geopackage.plist"),
                .copy("db/metadata/geopackage.tables.metadata.plist"),
                .copy("extension/nga/geopackage.tables.nga.plist"),
                .copy("geopackage.tables.plist"),
                .copy("dgiwg/dgiwg.wkt.plist"),
                .copy("extension/geopackage.tables.gpkg.plist"),
                .copy("extension/rtree/geopackage.rtree_sql.plist")
            ]
        ),
        .testTarget(
            name: "GeoPackageTests",
            dependencies: [
                "GeoPackage"
            ],
            path: "geopackage-iosTests",
            resources: [
                .copy("dgiwg/DMF_v2_0_Example_1.xml"),
                .copy("dgiwg/DMF_v2_0_Example_2.xml"),
                .copy("dgiwg/NMIS_v3_0_Example_1.xml"),
                .copy("dgiwg/NMIS_v3_0_Example_2.xml"),
                .copy("import_db.gpkg"),
                .copy("coverage_data.gpkg"),
                .copy("tiles2.gpkg"),
                .copy("tiles.gpkg"),
                .copy("rte.gpkg"),
                .copy("coverage_data_tiff.gpkg"),
                .copy("import_db_corrupt.gpkg"),
                .copy("example/15/6844/15_6844_12438.png"),
                .copy("example/15/6844/15_6844_12438.webp"),
                .copy("example/15/9357/15_9357_12551.png"),
                .copy("example/15/9357/15_9357_12552.png"),
                .copy("example/16/13689/16_13689_24876.png"),
                .copy("example/16/13689/16_13689_24877.png"),
                .copy("example/16/18714/16_18714_25103.png"),
                .copy("example/16/18714/16_18714_25104.png"),
                .copy("example/16/18715/16_18715_25103.png"),
                .copy("example/16/18715/16_18715_25104.png"),
                .copy("example/17/27378/17_27378_49753.png"),
                .copy("example/17/27378/17_27378_49754.png"),
                .copy("wgs84.png"),
                .copy("NGA_Logo.png"),
                .copy("tile.png"),
                .copy("NGA.jpg"),
                .copy("college.png"),
                .copy("BITSystems_Logo.png"),
                .copy("building.png"),
                .copy("tractor.png"),
                .copy("webMercator.png"),
                .copy("point.png"),
            ],
            cSettings: [
                .headerSearchPath(""),
                .headerSearchPath("attributes"),
                .headerSearchPath("contents"),
                .headerSearchPath("db"),
                .headerSearchPath("db/pool"),
                .headerSearchPath("db/table"),
                .headerSearchPath("dgiwg"),
                .headerSearchPath("extension"),
                .headerSearchPath("extension/coverage"),
                .headerSearchPath("extension/nga"),
                .headerSearchPath("extension/nga/contents"),
                .headerSearchPath("extension/nga/index"),
                .headerSearchPath("extension/nga/link"),
                .headerSearchPath("extension/nga/properties"),
                .headerSearchPath("extension/nga/scale"),
                .headerSearchPath("extension/nga/style"),
                .headerSearchPath("extension/related"),
                .headerSearchPath("extension/related/media"),
                .headerSearchPath("extension/related/simple"),
                .headerSearchPath("extension/rtree"),
                .headerSearchPath("extension/schema"),
                .headerSearchPath("extension/scheme/columns"),
                .headerSearchPath("extension/rtree"),
                .headerSearchPath("features"),
                .headerSearchPath("features/index"),
                .headerSearchPath("features/user"),
                .headerSearchPath("geom"),
                .headerSearchPath("io"),
                .headerSearchPath("map"),
                .headerSearchPath("map/features"),
                .headerSearchPath("srs"),
                .headerSearchPath("tiles"),
                .headerSearchPath("tiles/features"),
                .headerSearchPath("tiles/overlay"),
                .headerSearchPath("tiles/reproject"),
                .headerSearchPath("tiles/retriever"),
                .headerSearchPath("tiles/user"),
            ]
        )
    ]
)
