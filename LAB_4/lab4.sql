-- Bài 1: Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng if…else và case
-- Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là TenNV, cột thứ 2 nhận giá trị
SELECT N.TenNV,
       CASE 
           WHEN N.LUONG < (
                 SELECT AVG(LUONG)
                 FROM NhanVien
                 WHERE PHG = N.PHG
           ) THEN N'Tăng lương'
           ELSE N'Không tăng lương'
       END AS KetQua
FROM NhanVien AS N;

--Viết chương trình phân loại nhân viên dựa vào mức lương.
SELECT N.TenNV,
       CASE
           WHEN N.LUONG < (
                 SELECT AVG(LUONG)
                 FROM NhanVien
                 WHERE PHG = N.PHG
           ) THEN N'nhhân viên'
           ELSE N'trưởng phòng'
       END AS XepLoai
FROM NhanVien AS N;

--Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
SELECT CASE 
           WHEN PHAI = N'Nữ' THEN N'Ms. ' + TenNV
           ELSE N'Mr. ' + TenNV
       END AS TenNV
FROM NhanVien;

--Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
SELECT TenNV,
       LUONG,
       CASE
           WHEN LUONG <= 25000 THEN LUONG*0.10
           WHEN LUONG < 30000 THEN LUONG*0.12
           WHEN LUONG < 40000 THEN LUONG*0.15
           WHEN LUONG < 50000 THEN LUONG*0.20
           ELSE LUONG*0.25
       END AS Thue
FROM NhanVien;



----------------------------------------------------------------------



-- Bài 2: Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng vòng lặp 
-- Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
SELECT HONV, TENLOT, TENNV, MANV
FROM NHANVIEN
WHERE CAST(MANV AS INT) % 2 = 0;

-- Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng không tính nhân viên có MaNV là 4.
SELECT HONV, TENLOT, TENNV, MANV
FROM NHANVIEN
WHERE CAST(MANV AS INT) % 2 = 0
  AND CAST(MANV AS INT) <> 4;



  ---------------------------------------------------------------------



  -- Bài 3: Quản lý lỗi chương trình
  -- 3.a) Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước 
  -- Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
  BEGIN TRY
    INSERT INTO PHONGBAN(TENPHG, MAPHG, TRPHG)
    VALUES (N'Tiếp viên hàng không', 7, 001);  
    PRINT N'Thêm dữ liệu thành công';
END TRY
BEGIN CATCH
    PRINT N'Thêm dữ liệu thất bại';
END CATCH;


-- Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai” từ khối Catch
BEGIN TRY
    INSERT INTO PHONGBAN(MaPHG, TenPHG, TRPHG)
    VALUES ('ABC', N'Nhân Sự', N'HCM');   -- Sai kiểu INT

    PRINT N'Thêm dữ liệu thành công';
END TRY
BEGIN CATCH
    PRINT N'Thêm dữ liệu thất bại';
END CATCH;

--Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng RAISERROR để thông báo lỗi. 
BEGIN TRY
    DECLARE @chia INT = 100;
    DECLARE @ketqua INT;

    -- phép chia 0 -> lỗi
    SET @ketqua = @chia / 0;
END TRY
BEGIN CATCH
    RAISERROR (N'Lỗi: Không thể chia cho 0', 16, 1);
END CATCH;

--16 = Mức độ nghiêm trọng (Severity) cho lỗi người dùng.
--1 = State (trạng thái, chỉ số tuỳ chọn).

