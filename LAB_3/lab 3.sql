--Bài 1:Sử dụng cơ sở dữ liệu QLDA. Với mỗi câu truy vấn cần thực hiện bằng 2 cách, dùng cast và convert. 
--Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân. 
SELECT DA.TENDEAN,
       CAST(SUM(PC.THOIGIAN) AS DECIMAL(10,2)) AS TongGio
FROM   DEAN DA
       JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;
-- Xuất định dạng “tổng số giờ làm việc” kiểu varchar {CONVERT(VARCHAR... chuỗi varchar có định dạng}
SELECT DA.TENDEAN,
       CONVERT(VARCHAR, SUM(PC.THOIGIAN)) AS TongGio
FROM   DEAN DA
       JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;
--Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu phẩy để phân biệt phần nguyên và phần thập phân. FORMAT(number,'N2') → tự động có dấu ngăn cách hàng nghìn và 2 số lẻ.
SELECT PB.TENPHG,
       FORMAT(AVG(NV.LUONG),'N2') AS LuongTB
FROM   PHONGBAN PB
       JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;
--  Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3 chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace 
SELECT PB.TENPHG,
       REPLACE(CONVERT(VARCHAR, CAST(AVG(NV.LUONG) AS MONEY), 1), '.00','') AS LuongTB
FROM   PHONGBAN PB
       JOIN NHANVIEN NV ON PB.MAPHG = NV.PHG
GROUP BY PB.TENPHG;


----------------------------------------------------------


--Bài 2: Sử dụng các hàm toán học 
-- 2.a) Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
--Xuất định dạng “tổng số giờ làm việc” với hàm CEILING 
SELECT DA.TENDEAN,
       CEILING(SUM(PC.THOIGIAN)) AS TongGio_Ceiling
FROM   DEAN DA
       JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

--Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
SELECT DA.TENDEAN,
       FLOOR(SUM(PC.THOIGIAN)) AS TongGio_Floor
FROM   DEAN DA
       JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

--Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
SELECT DA.TENDEAN,
       ROUND(SUM(PC.THOIGIAN), 2) AS TongGio_2So
FROM   DEAN DA
       JOIN PHANCONG PC ON DA.MADA = PC.MADA
GROUP BY DA.TENDEAN;

-- 2.b) Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu" 
SELECT NV.HONV, NV.TENLOT, NV.TENNV, NV.LUONG
FROM   NHANVIEN NV
       JOIN PHONGBAN PB ON NV.PHG = PB.MAPHG
WHERE  NV.LUONG >
       (
         SELECT ROUND(AVG(NV2.LUONG), 2)             -- làm tròn đến 2 số thập
         FROM   NHANVIEN NV2
                JOIN PHONGBAN PB2 ON NV2.PHG = PB2.MAPHG
         WHERE  PB2.TENPHG = N'Nghiên cứu'
       );


       --------------------------------------------------------------------------


-- Bài 3: Sử dụng các hàm xử lý chuỗi
-- 3.a) Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, thỏa các yêu cầu
SELECT DISTINCT
       UPPER(NV.HONV) AS HoNV,                           -- In hoa toàn bộ
       LOWER(NV.TENLOT) AS TenLot,                        -- Chữ thường toàn bộ
       LOWER(LEFT(NV.TENNV,1)) +                          -- Ký tự 1 thường   // lấy lí tự bên trái
       UPPER(SUBSTRING(NV.TENNV,2,1)) +                   -- Ký tự 2 hoa
       LOWER(SUBSTRING(NV.TENNV,3,LEN(NV.TENNV)-2)) AS TenNV,  -- Phần còn lại thường
       -- Lấy phần tên đường sau khoảng trắng đầu tiên
       LTRIM(SUBSTRING(NV.DCHI, CHARINDEX(' ', NV.DCHI)+1, LEN(NV.DCHI))) AS Duong        --CHARINDEX tìm vị trí khoảng trắng đầu tiên
FROM   NHANVIEN NV                                                                            -- LTRIM loại bỏ khoảng trắng đầu chuỗi
WHERE  NV.MANV IN (
         SELECT MA_NVIEN
         FROM   THANNHAN
         GROUP BY MA_NVIEN             -- lọc nhân viên ...
         HAVING COUNT(*) > 2           -- ... có trên 2 thân nhân.
       );


-- 3.b) Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất, hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly” 
SELECT TOP 1 --để tìm phòng đông nhân viên nhất.
       PB.TENPHG AS TenPhongBan,
       NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS TruongPhong,
       'Fpoly' AS TenThayThe   -- thêm polu bằng đặt chuỗi
FROM   PHONGBAN PB
       JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
       JOIN NHANVIEN N2 ON PB.MAPHG = N2.PHG
GROUP BY PB.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV
ORDER BY COUNT(N2.MANV) DESC;   -- Sắp xếp giảm dần số lượng NV     // để tìm phòng đông nhân viên nhất.


----------------------------------------------------------------------------------



-- Bài 4: Sử dụng các hàm ngày tháng năm
-- Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
SELECT HONV, TENLOT, TENNV, NGSINH
FROM   NHANVIEN
WHERE  YEAR(NGSINH) BETWEEN 1960 AND 1965; --Trích năm

-- Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại. 
SELECT HONV, TENLOT, TENNV,
       DATEDIFF(YEAR, NGSINH, GETDATE())
         - CASE 
             WHEN DATEADD(YEAR, DATEDIFF(YEAR, NGSINH, GETDATE()), NGSINH) > GETDATE() --Khoảng cách giữa 2 ngày
             THEN 1 ELSE 0
           END AS Tuoi
FROM   NHANVIEN;

-- Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy. 
SELECT HONV, TENLOT, TENNV,
       DATENAME(WEEKDAY, NGSINH) AS ThuSinh --Tên thứ
FROM   NHANVIEN;

-- Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)
SELECT PB.TENPHG,
       NV.HONV + ' ' + NV.TENLOT + ' ' + NV.TENNV AS TruongPhong,
       COUNT(NV2.MANV) AS SoLuongNhanVien,
       FORMAT(PB.NG_NHANCHUC, 'dd-MM-yy') AS NgayNhanChuc --Định dạng ngày theo mẫu
FROM   PHONGBAN PB
       JOIN NHANVIEN NV ON PB.TRPHG = NV.MANV
       LEFT JOIN NHANVIEN NV2 ON PB.MAPHG = NV2.PHG
GROUP BY PB.TENPHG, NV.HONV, NV.TENLOT, NV.TENNV, PB.NG_NHANCHUC;
