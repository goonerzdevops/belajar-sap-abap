REPORT zmm_report_po.

" ====================================================================
" Laporan Sederhana Modul MM (Purchase Order)
" Menghubungkan Header (EKKO) dan Line Item (EKPO)
" ====================================================================

" 1. AMBIL DATA DARI DATABASE (READ)
" Menggunakan INNER JOIN dan membatasi data (UP TO 50 ROWS)
" agar server HANA tidak hang saat menarik jutaan data di sistem riil.
SELECT ekko~ebeln AS po_number,      " Nomor PO
       ekko~bsart AS doc_type,       " Jenis Dokumen
       ekko~aedat AS creation_date,  " Tanggal Dibuat
       ekko~lifnr AS vendor_id,      " Nomor Vendor
       ekpo~ebelp AS item_number,    " Nomor Item (Line Item)
       ekpo~matnr AS material_id,    " Nomor Material
       ekpo~txz01 AS description,    " Deskripsi Singkat
       ekpo~menge AS quantity,       " Jumlah Qty
       ekpo~meins AS unit_of_measure " Satuan (UoM)
  FROM ekko
  INNER JOIN ekpo
    ON ekko~ebeln = ekpo~ebeln
  INTO TABLE @DATA(lt_po_data)
  UP TO 50 ROWS.

" 2. TAMPILKAN KE LAYAR ALV
IF sy-subrc = 0.
  " Cetak data array lt_po_data ke layar GUI
  cl_demo_output=>display( lt_po_data ).
ELSE.
  MESSAGE 'Tidak ada data Purchase Order (ME21N) yang ditemukan di sistem!' TYPE 'I'.
ENDIF.
