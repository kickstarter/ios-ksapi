import Foundation
import MobileCoreServices

extension Data {
  internal var imageMime: String? {
    guard let byte: UInt8 = UnsafeBufferPointer(start: (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count), count: 1).first
      else { return nil }
    switch byte {
    case 0xFF:
      return mimeType(uti: kUTTypeJPEG)
    case 0x89:
      return mimeType(uti: kUTTypePNG)
    case 0x47:
      return mimeType(uti: kUTTypeGIF)
    default:
      return nil
    }
  }
}

extension URL {
  internal var imageMime: String? {
    return pathExtension.flatMap { mimeType(extension: $0, where: kUTTypeImage) }
  }
}

private func mimeType(extension: String, where: CFString? = nil) -> String? {
  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, `extension` as CFString, `where`)?
    .takeRetainedValue()
  return uti.flatMap(mimeType(uti:))
}

private func mimeType(uti: CFString) -> String? {
  return UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as String?
}
