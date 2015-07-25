(module qrencode
  (QR-encode-string
   QR-encode-string-8bit
   QR-encode-data
   MQR-encode-string
   MQR-encode-string-8bit
   MQR-encode-data)

(import chicken scheme foreign)
(use srfi-4 lolevel)

;; TODO Structured QR encoding

(foreign-declare "#include \"qrencode/qrencode.h\"")

(define errno/erange 34)

(define (QR-encoding mode)
  (case mode
    ((#:numeric) 0)
    ((#:alpha-numeric) 1)
    ((#:8-bit) 2)
    ((#:kangi) 3)
    ((#:eci) 5)
    ((#:fnc-first) 6)
    ((#:fnc-second) 7)
    (else (error 'QR-encode-mode "Not a valide QR encoding" mode))))

(define (check-error-correction-level level)
  (assert (<= 0 level 3)
          "Error correction level must be between 0 and 3" level))

(define (check-QR-version version)
  (assert (<= 0 version 40)
          "QR version must be between 1 and 40" version))

(define (check-MQR-version version)
  (assert (<= 1 version 40)
          "MQR version must be between 1 and 4" version))

(define (QRcode-free code)
  (foreign-lambda void "QRcode_free" c-pointer))

(define (QR-error)
  (case (errno)
    ((errno/inval) (error "QR encoding failed: invalid arguments"))
    ((errno/range) (error "QR encoding failed: input data too large"))
    ((errno/nomem) (error "QR encoding failed: out of memory"))))

(define (get-QR-data QRcode)
  (unless QRcode (QR-error))
  (let* ((width (pointer-s32-ref (pointer+ QRcode 4)))
         (data (make-u8vector (* width width))))
    ((foreign-lambda* void ((u8vector dest) (c-pointer qrcode))
       "\
QRcode *code = (QRcode *) qrcode;
int width = code->width;
unsigned char *src = code->data;
int i, j;
for (j = 0; j < width; j++) {
    for (i = 0; i < width; i++) {
        dest[j + i*width] = (src[i + j*width] & 1) * 255;
    }
}")
     data QRcode)
    (QRcode-free QRcode)
    (values data width)))

(define (QR-encode-string string #!optional
                          (version 0) (level 2)
                          (hint #:8-bit)
                          (case-sensitive? #t))
  (check-QR-version version)
  (check-error-correction-level level)
  (get-QR-data
   ((foreign-lambda c-pointer "QRcode_encodeString"
      c-string int int int bool)
    string version level (QR-encoding hint) case-sensitive?)))

(define (QR-encode-string-8bit string version level)
  (check-QR-version version)
  (check-error-correction-level level)
  (get-QR-data
   ((foreign-lambda c-pointer "QRcode_encodeString8bit"
      c-string int int)
    string version level)))

(define (MQR-encode-string string #!optional (version 0) (level 2)
                          (hint #:8-bit)
                          (case-sensitive? #t))
  (check-MQR-version version)
  (check-error-correction-level level)
  (get-QR-data
   ((foreign-lambda c-pointer "QRcode_encodeStringMQR"
      c-string int int int bool)
    string version level (QR-encoding hint) case-sensitive?)))

(define (MQR-encode-string-8bit string #!optional (version 0) (level 2))
  (check-MQR-version version)
  (check-error-correction-level level)
  (get-QR-data
   ((foreign-lambda c-pointer "QRcode_encodeString8bitMQR"
      c-string int int)
    string version level)))

(define (QR-encode-data u8vector #!optional (version 0) (level 2))
  (check-QR-version version)
  (check-error-correction-level level)
  (get-QR-data
   ((foreign-lambda c-pointer "QRcode_encodeData"
      int u8vector int int)
    (u8vector-length u8vector) u8vector version level)))

(define (MQR-encode-data u8vector #!optional (version 0) (level 2))
  (check-MQR-version version)
  (check-error-correction-level level)
  (get-QR-data
   ((foreign-lambda c-pointer "QRcode_encodeDataMQR"
      int u8vector int int)
    (u8vector-length u8vector) u8vector version level)))

) ; end module qrencode
