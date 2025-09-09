import SwiftUI
import MapKit

struct SwiftUIMapBackend: View {
    let assets: [AssetSignal]
    let flows: [AssetFlow]
    let riskStyling: RiskStyling
    let onAssetTap: (AssetSignal) -> Void
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(assets) { asset in
                Annotation(asset.name, coordinate: asset.coordinate) {
                    AssetDotView(asset: asset, riskStyling: riskStyling)
                        .onTapGesture {
                            onAssetTap(asset)
                        }
                }
                .annotationTitles(.hidden)
            }
        }
        .mapStyle(.globe(elevation: .realistic))
        .mapCameraKeyframeAnimator(trigger: cameraPosition) { camera in
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(1000000, duration: 1.2)
            }
        }
    }
}

#Preview {
    let sampleAssets = [
        AssetSignal(
            id: "BTC",
            name: "Bitcoin",
            type: .crypto,
            latitude: 37.7749,
            longitude: -122.4194,
            value: 1.24,
            risk: .medium,
            country: "US",
            ts: Date()
        ),
        AssetSignal(
            id: "NGN",
            name: "Naira",
            type: .currency,
            latitude: 9.0579,
            longitude: 7.4951,
            value: 3.12,
            risk: .high,
            country: "NG",
            ts: Date()
        )
    ]
    
    let sampleFlows = [
        AssetFlow(
            id: "F1",
            fromLat: 6.5244,
            fromLon: 3.3792,
            toLat: 25.2048,
            toLon: 55.2708,
            magnitude: 0.8,
            classTag: .currency,
            ts: Date()
        )
    ]
    
    return SwiftUIMapBackend(
        assets: sampleAssets,
        flows: sampleFlows,
        riskStyling: RiskStyling(),
        onAssetTap: { _ in },
        cameraPosition: .constant(.automatic)
    )
}
