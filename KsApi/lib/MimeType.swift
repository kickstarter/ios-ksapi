import Foundation
import MobileCoreServices

extension NSData {
  internal var imageMime: String? {
    guard let byte: UInt8 = UnsafeBufferPointer(start: UnsafePointer(self.bytes), count: 1).first
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

extension NSURL {
  internal var imageMime: String? {
    return pathExtension.flatMap { mimeType(extension: $0, where: kUTTypeImage) }
  }
}

private func mimeType(extension extension: String, where: CFString? = nil) -> String? {
  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, `extension`, `where`)?
    .takeRetainedValue()
  return uti.flatMap(mimeType(uti:))
}

private func mimeType(uti uti: CFString) -> String? {
  return UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as String?
}
