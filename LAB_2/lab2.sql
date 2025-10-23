

/* HÌNH CHỮ NHẬT */
-- Cách 1: Dùng biến vô hướng
DECLARE @Dai FLOAT, @Rong FLOAT;
DECLARE @DienTich FLOAT, @ChuVi FLOAT;

SET @Dai = 10;
SET @Rong = 5;

SET @DienTich = @Dai * @Rong;
SET @ChuVi = 2 * (@Dai + @Rong);

PRINT N'CÁCH 1: ';
PRINT N'Chiều dài = ' + CAST(@Dai AS VARCHAR(10)); --chuyển kiểu
PRINT N'Chiều rộng = ' + CAST(@Rong AS VARCHAR(10));
PRINT N'Diện tích = ' + CAST(@DienTich AS VARCHAR(10));
PRINT N'Chu vi = ' + CAST(@ChuVi AS VARCHAR(10));

-- Cách 2: Dùng biến bảng
DECLARE @HinhChuNhat TABLE (
    Dai FLOAT,
    Rong FLOAT,
    DienTich FLOAT,
    ChuVi FLOAT
);
INSERT INTO @HinhChuNhat(Dai, Rong, DienTich, ChuVi)
VALUES (10, 5, 10*5, 2*(10+5));
PRINT N'CÁCH 2: ';
SELECT * FROM @HinhChuNhat;

--BÀI 2:  Dựa trên csdl QLDA thực hiện truy vấn, 
--các giá trị truyền vào và trả ra phải dưới dạng sử dụng biến. 
USE QLDA;
GO

--1: Cho biêt nhân viên có lương cao nhất 
SELECT * FROM NHANVIEN
WHERE LUONG = (SELECT MAX(LUONG) FROM NHANVIEN);


--2: Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng "Nghiên cứu” 
SELECT NV.HONV, NV.TENLOT, NV.TENNV, NV.LUONG
FROM NHANVIEN NV JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
WHERE PB.TENPHG = N'Nghiên cứu'
  AND NV.LUONG > (
        SELECT AVG(NV2.LUONG)
        FROM NHANVIEN NV2
        JOIN PHONGBAN PB2 ON NV2.PHG = PB2.MAPHG
        WHERE PB2.TENPHG = N'Nghiên cứu'
      );


--3: Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó. 
      SELECT PB.TENPHG, COUNT(NV.MANV) AS SoLuongNhanVien
FROM PHONGBAN PB JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG
HAVING AVG(NV.LUONG) > 30000;


--4: Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì
SELECT PB.TENPHG, COUNT(DA.MADA) AS SoLuongDeAn
FROM PHONGBAN PB
LEFT JOIN DEAN DA ON PB.MAPHG = DA.PHONG
GROUP BY PB.TENPHG;