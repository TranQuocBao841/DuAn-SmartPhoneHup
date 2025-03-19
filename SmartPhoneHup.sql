-- Xóa bảng nếu đã tồn tại để tránh lỗi khi tạo lại
--DROP TABLE IF EXISTS hoa_don_chi_tiet, hoa_don, tai_khoan, nhan_vien, khach_hang, sp_chi_tiet, kich_thuoc, mau_sac, san_pham;
--GO
Create database ShopDB
-- Tạo bảng sản phẩm
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma NVARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(255) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);
GO

-- Bảng màu sắc
CREATE TABLE mau_sac (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma NVARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);
GO

-- Bảng kích thước
CREATE TABLE kich_thuoc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma NVARCHAR(50) NOT NULL UNIQUE,
    ten NVARCHAR(100) NOT NULL,
    trang_thai INT NOT NULL DEFAULT 1
);
GO

-- Bảng sản phẩm chi tiết
CREATE TABLE sp_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma_spct NVARCHAR(50) NOT NULL UNIQUE,
    id_mau_sac INT NOT NULL,
    id_kich_thuoc INT NOT NULL,
    id_san_pham INT NOT NULL,
    so_luong INT NOT NULL CHECK (so_luong >= 0),
    don_gia DECIMAL(18,2) NOT NULL CHECK (don_gia >= 0),
    trang_thai INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_sp_mau FOREIGN KEY (id_mau_sac) REFERENCES mau_sac(id),
    CONSTRAINT fk_sp_kt FOREIGN KEY (id_kich_thuoc) REFERENCES kich_thuoc(id),
    CONSTRAINT fk_sp FOREIGN KEY (id_san_pham) REFERENCES san_pham(id)
);
GO

-- Bảng khách hàng
CREATE TABLE khach_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten NVARCHAR(255) NOT NULL,
    sdt NVARCHAR(15) NOT NULL UNIQUE,
    ma_kh NVARCHAR(20) NOT NULL UNIQUE,
    trang_thai INT NOT NULL DEFAULT 1
);
GO

-- Bảng nhân viên
CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten NVARCHAR(255) NOT NULL,
    ma_nv NVARCHAR(20) NOT NULL UNIQUE,
    trang_thai INT NOT NULL DEFAULT 1
);
GO

-- Bảng tài khoản (dùng chung cho khách hàng & nhân viên)
CREATE TABLE tai_khoan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_dang_nhap NVARCHAR(50) NOT NULL UNIQUE,
    mat_khau NVARCHAR(255) NOT NULL,
    loai_tai_khoan INT NOT NULL CHECK (loai_tai_khoan IN (1,2)), -- 1: Nhân viên, 2: Khách hàng
    id_nguoi_dung INT NOT NULL,
    CONSTRAINT fk_tk_kh UNIQUE (id_nguoi_dung, loai_tai_khoan),
    CONSTRAINT fk_tk_nguoi_dung_kh FOREIGN KEY (id_nguoi_dung) REFERENCES khach_hang(id) ON DELETE CASCADE,
    CONSTRAINT fk_tk_nguoi_dung_nv FOREIGN KEY (id_nguoi_dung) REFERENCES nhan_vien(id) ON DELETE CASCADE
);
GO

-- Bảng hóa đơn
CREATE TABLE hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_khach_hang INT NOT NULL,
    id_nhan_vien INT NOT NULL,
    ngay_mua_hang DATETIME NOT NULL DEFAULT GETDATE(),
    tong_tien DECIMAL(18,2) NULL,
    trang_thai INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_hd_kh FOREIGN KEY (id_khach_hang) REFERENCES khach_hang(id),
    CONSTRAINT fk_hd_nv FOREIGN KEY (id_nhan_vien) REFERENCES nhan_vien(id)
);
GO

-- Bảng chi tiết hóa đơn
CREATE TABLE hoa_don_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_spct INT NOT NULL,
    id_hoa_don INT NOT NULL,
    so_luong INT NOT NULL CHECK (so_luong > 0),
    don_gia DECIMAL(18,2) NOT NULL CHECK (don_gia > 0),
    trang_thai INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_hdct_spct FOREIGN KEY (id_spct) REFERENCES sp_chi_tiet(id),
    CONSTRAINT fk_hdct_hd FOREIGN KEY (id_hoa_don) REFERENCES hoa_don(id)
);
GO

-- Thêm dữ liệu mẫu
INSERT INTO san_pham (ma, ten, trang_thai) VALUES 
(N'SP001', N'Laptop Dell XPS 13', 1),
(N'SP002', N'MacBook Air M2', 1),
(N'SP003', N'Asus ROG Strix', 1);

INSERT INTO mau_sac (ma, ten, trang_thai) VALUES 
(N'MS001', N'Đen', 1),
(N'MS002', N'Trắng', 1);

INSERT INTO kich_thuoc (ma, ten, trang_thai) VALUES 
(N'KT001', N'13 inch', 1),
(N'KT002', N'15 inch', 1);

INSERT INTO khach_hang (ten, sdt, ma_kh, trang_thai) VALUES 
(N'Nguyễn Văn A', N'0987654321', N'KH001', 1),
(N'Trần Thị B', N'0912345678', N'KH002', 1);

INSERT INTO nhan_vien (ten, ma_nv, trang_thai) VALUES 
(N'Phạm Văn D', N'NV001', 1),
(N'Hoàng Thị E', N'NV002', 1);

INSERT INTO tai_khoan (ten_dang_nhap, mat_khau, loai_tai_khoan, id_nguoi_dung) VALUES 
(N'phamvand', N'123456', 1, 1), 
(N'hoangthie', N'abcdef', 1, 2), 
(N'nguyenvana', N'khach123', 2, 1), 
(N'tranthib', N'khach456', 2, 2);

INSERT INTO hoa_don (id_khach_hang, id_nhan_vien, ngay_mua_hang, trang_thai) VALUES 
(1, 1, '2025-02-15 10:00:00', 1),
(2, 2, '2025-02-14 14:30:00', 1);

-- Thêm sản phẩm chi tiết vào bảng `sp_chi_tiet`
INSERT INTO sp_chi_tiet (ma_spct, id_mau_sac, id_kich_thuoc, id_san_pham, so_luong, don_gia, trang_thai) VALUES
(N'SPCT001', 1, 1, 1, 10, 25000000, 1), -- Laptop Dell XPS 13 - Đen - 13 inch
(N'SPCT002', 2, 2, 2, 5, 30000000, 1),  -- MacBook Air M2 - Trắng - 15 inch
(N'SPCT003', 1, 1, 3, 8, 27000000, 1);  -- Asus ROG Strix - Đen - 13 inch


-- Thêm chi tiết hóa đơn (mỗi hóa đơn có sản phẩm)
INSERT INTO hoa_don_chi_tiet (id_spct, id_hoa_don, so_luong, don_gia, trang_thai) VALUES 
(1, 1, 1, 25000000, 1), -- Laptop Dell XPS 13 cho hóa đơn 1
(2, 2, 2, 30000000, 1), -- MacBook Air M2 cho hóa đơn 2
(3, 1, 1, 27000000, 1); -- Asus ROG Strix cho hóa đơn 1

-- Cập nhật tổng tiền hóa đơn
UPDATE hoa_don 
SET tong_tien = (SELECT SUM(hdct.so_luong * hdct.don_gia) FROM hoa_don_chi_tiet hdct WHERE hdct.id_hoa_don = hoa_don.id);
GO

-- Kiểm tra lại dữ liệu


select*from hoa_don
select*from  hoa_don_chi_tiet
select*from khach_hang
select*from kich_thuoc
select*from mau_sac
select*from nhan_vien
select*from san_pham
select*from sp_chi_tiet
select*from tai_khoan

--UPDATE hoa_don Công Thức Tính tổng tiền
--SET tong_tien = (
--    SELECT SUM(hdct.so_luong * hdct.don_gia) 
--    FROM hoa_don_chi_tiet hdct 
--    WHERE hdct.id_hoa_don = hoa_don.id
--);