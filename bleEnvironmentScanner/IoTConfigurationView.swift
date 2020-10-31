//
//  IoTConfigurationView.swift
//  bleEnvironmentScanner
//
//  Created by Thomas Petz, Jr. on 10/25/20.
//

import SwiftUI
import CoreBluetooth

struct IoTConfigurationView: View {
    
    static let serviceUUID = CBUUID(string: "44af2abf-f3d9-4429-bbb8-ec770f1e355a")
    static let ssidCharacteristicUUID = CBUUID(string: "0465ac13-a0f3-46a6-990a-5a04b32b3b60")
    static let wifiPasswordCharacteristicUUID = CBUUID(string: "27030384-eac9-4907-8e44-5c16d778aa7a")
    static let hostNameCharacteristicUUID = CBUUID(string: "ef42bf97-1b9c-4d45-941d-d60dc564dc6f")
    static let mqttBrokerCharacteristicUUID = CBUUID(string: "0d071785-b22b-49d6-86be-270de52da930")
    static let rootTopicCharacteristicUUID = CBUUID(string: "18cda5b0-3b76-4319-9716-acd1a409d3f6")
    static let sampleIntervalCharacteristicUUID = CBUUID(string: "1682229f-bb5c-4f4a-96a9-1027f13d83f9")
    static let configIsLockedCharacteristicUUID = CBUUID(string: "d02db20e-6e1f-4541-bd3d-7715e00b2b82")
    static let lockPasswordCharacteristicUUID = CBUUID(string: "29636a43-d59a-46a1-ad0a-34aa23a0e90c")

    
    @ObservedObject var service: Service

    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text("IoT Sensor Configuration Service").font(.headline)
            Spacer()
            if let ssid = service.getCharacteristic(cbuuid: IoTConfigurationView.ssidCharacteristicUUID) {
                CharacteristicView(characteristic: ssid) {
                    "ssid: \(decodeString(ssid.value))"
                }
            }
            if let wifiPassword = service.getCharacteristic(cbuuid: IoTConfigurationView.wifiPasswordCharacteristicUUID) {
                CharacteristicView(characteristic: wifiPassword) {
                    "WiFi Password: "
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: IoTConfigurationView.hostNameCharacteristicUUID) {
                CharacteristicView(characteristic: characteristic) {
                    "Hostname: \(decodeString(characteristic.value))"
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: IoTConfigurationView.mqttBrokerCharacteristicUUID) {
                CharacteristicView(characteristic: characteristic) {
                    "MQTT Broker: \(decodeString(characteristic.value))"
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: IoTConfigurationView.rootTopicCharacteristicUUID) {
                CharacteristicView(characteristic: characteristic) {
                    "MQTT Root Topic: \(decodeString(characteristic.value))"
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: IoTConfigurationView.configIsLockedCharacteristicUUID) {
                CharacteristicView(characteristic: characteristic) {
                    String(format: "Configuration is Locked: %d", Int((characteristic.value?.getUInt8()) ?? 0))
                }
            }
            if let characteristic = service.getCharacteristic(cbuuid: IoTConfigurationView.lockPasswordCharacteristicUUID) {
                CharacteristicView(characteristic: characteristic) {
                    "Lock Password: "
                }
            }
      }
        .padding(4)
    }
}
