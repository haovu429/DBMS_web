
---------VIEW--------------

-- Hiển thị thông tin sản phẩm
CREATE VIEW vw_ThongTinSanPham AS
SELECT "name", "image", price, title, "description"
FROM Product;
GO
-- Quản lý thông tin cá nhân
CREATE VIEW ThongTinCaNhan AS
SELECT name, age, email, phone, address
FROM Member;
GO

-- Thông tin chi tiết các đơn hàng---
CREATE VIEW vw_ThongTinChiTietCacDonHang AS
SELECT D."oid",p."name", p."image",D.Quantity, price*D."Quantity" AS price, state
FROM Product P INNER JOIN "DetailOrder" D ON P.id = D.pid
INNER JOIN "Order" O ON D.oid = O.oid
GO

-- Quản lý người dùng---
GO
CREATE VIEW ThongTinNguoiDung AS
SELECT "uid", "user", isSell, isAdmin
FROM Account;
GO


---Trigger---

--Tự động tạo account và cấp quyền khi thêm dữ liệu trong bảng account--.
CREATE TRIGGER AutoCreateUserDB ON "Account"
FOR INSERT
AS
BEGIN 
	DECLARE @LGNAME NVARCHAR(50), @PASS NVARCHAR(50), @ROLE INT;
	SELECT @LGNAME= new."user", @PASS = new.pass, @ROLE = new.isAdmin
	FROM Account old, Inserted new
	WHERE old."uid" = new."uid"
	IF @ROLE= 2
		BEGIN
			--EXEC sp_addrolemember 'ADMIN', @LGNAME
			EXEC USP_CREATE_LOGIN_USER 'ADMIN',@LGNAME,@PASS
		END

	IF @ROLE= 1
		BEGIN 
			--EXEC sp_addrolemember 'SELLER', @LGNAME
			EXEC USP_CREATE_LOGIN_USER 'SELLER',@LGNAME,@PASS
		END
	IF @ROLE= 0
		BEGIN  
			--EXEC sp_addrolemember 'CUSTOMER', @LGNAME
			EXEC USP_CREATE_LOGIN_USER 'CUSTOMER',@LGNAME,@PASS
		END
END
go

--Những người dùng có tuổi nhỏ hơn 10 sẽ không thể mua hàng.
CREATE TRIGGER Prevent_Age_lr_10 ON "Order"
FOR INSERT, UPDATE 
AS
BEGIN 
	IF EXISTS (SELECT*
			FROM "Order" O, Member M
			WHERE O."uid" = M.Mid AND M.Age <10)
	BEGIN
		RAISERROR(N'người dùng tuổi nhỏ hơn 10 không thể mua hàng',16,1)
		ROLLBACK TRANSACTION
	END

END
go


--Giảm giá 25% cho các sản phẩm thuộc danh mục 'socks'
CREATE TRIGGER Discount_for_Cat ON "DetailOrder"
AFTER INSERT 
AS
BEGIN 
	DECLARE @oid INT, @TenSP NVARCHAR(50)
	SELECT @oid=I.oid, @TenSP=P."name"
	FROM inserted I,Product P,DetailOrder D
	WHERE I.oid = D.oid AND D.pid = P.id
	IF (@TenSP ='socks')
	BEGIN 
		UPDATE "Order"
			SET totalMoney = totalMoney*0.75
			WHERE Oid = @oid
	END
END
Go

---Tu dong them ngay mua trong Orrder----
CREATE TRIGGER tg_AutoDate ON "Order" 
AFTER INSERT 
AS
DECLARE @oid INT , @ngay DATE = getDATE()
SELECT @oid = inserted."oid"
FROM inserted
BEGIN
	UPDATE "Order"
	SET purchaseDate = @ngay
	WHERE oid = @oid
END

go

---Tính số lượng món hàng, TotalMoney cho Order khi sửa trong DetailOder----co dùng TRANSACTION--Kèm giảm giá người già
CREATE TRIGGER tg_TotalQuantityMoneyOfOrder_inOder ON "Order"
AFTER INSERT,UPDATE
AS
DECLARE @oid INT, @totalMoney FLOAT, @totalQuantity INT
SELECT @oid=I.oid, @totalMoney=SUM(P."price" *D."Quantity")
	 ,@totalQuantity = SUM(D."Quantity")
FROM inserted I,Product P,DetailOrder D
WHERE I.oid = D.oid AND D.pid = P.id
GROUP BY I.oid
BEGIN 
	BEGIN TRAN 
	UPDATE "Order"
		SET totalMoney = @totalMoney, totalQuantity = @totalQuantity
		WHERE oid = @oid
	SAVE TRANSACTION thanhtoan
	DECLARE  @tuoi INT, @giaCu FLOAT, @giamoi FLOAT
	SELECT @oid=I.oid,@tuoi = M.age, @giaCu = I.totalMoney
	FROM "Order" I,Member M, Inserted new
	WHERE I.uid = M.mid AND I.uid = new.uid
	print(@tuoi)
	IF (@tuoi >=70 )
	BEGIN
		UPDATE "Order"
			SET totalMoney = totalMoney*0.9, @giamoi = totalMoney*0.9
			WHERE oid = @oid
		IF (@giamoi < 1000000)
		BEGIN
			RAISERROR('Tong don hang phai tren 1 trieu',16,1)
			ROLLBACK TRANSACTION thanhtoan
		END
	END
	
	COMMIT TRAN tinhtien
END
go

---Tính số lượng món hàng, TotalMoney cho Order khi sửa trong DetailOder----
CREATE TRIGGER tg_TotalQuantityMoneyOfOrder ON "DetailOrder"
AFTER INSERT,UPDATE
AS
DECLARE @oid INT, @totalMoney FLOAT,  @totalQuantity INT
SELECT @oid=I.oid, @totalMoney=SUM(P."price" *D."Quantity")
		,@totalQuantity = SUM(D."Quantity")
FROM inserted I,Product P,DetailOrder D
WHERE I.oid = D.oid AND D.pid = P.id
GROUP BY I.oid
BEGIN 
	UPDATE "Order"
		SET totalMoney = @totalMoney, totalQuantity = @totalQuantity
		WHERE oid = @oid
END
GO




---Strored Procedure---
--Các bảng cơ bản Thêm, xoá, sửa, lấy tất cả, lấy một theo field--


--------------Contact-----------------

--lấy tất cả Contact---
CREATE PROC sp_getAllContact
AS
BEGIN
    SELECT 
		"name", 
		"email",
		"message"
    FROM 
        "Contact"
    ORDER BY 
        "name";
END;
go

--Lấy một Contact--
CREATE PROC sp_getOneContact 
(
	@name NVARCHAR(50)
)
AS
BEGIN
    SELECT 
		"name", 
		"email",
		"message"
    FROM 
        "Contact"
    WHERE 
        "name"= @name
END;
go

--Xoá Contact--
CREATE PROC sp_DeleteContact
(
	@name NVARCHAR(50)
)
AS
BEGIN
    DELETE 
    FROM 
        "Contact"
    WHERE
        "name"= @name
END;
go

--Thêm Contact--
CREATE PROC sp_InsertContact
(
	@name NVARCHAR(50),
	@email NVARCHAR(50),
	@message NVARCHAR(MAX)
)
AS
	INSERT INTO "Contact"("name","email","message")
	VALUES (@name,@email,@message)
go

--Cập nhật Contact--
CREATE PROC sp_UpdateContact
(
	@name NVARCHAR(50),
	@email NVARCHAR(50),
	@message NVARCHAR(MAX)
)
AS
	UPDATE "Contact" SET 
					"email" = @email,
					"message" = @message
	WHERE "name" = @name

go

--------------Account-----------------

--lấy tất cả Account---
CREATE PROC sp_getAllAccount
AS
BEGIN
    SELECT 
		"uid", 
		"user",
		"pass",
		"isSell",
		"isAdmin"
    FROM 
        "Account"
    ORDER BY 
        "uid";
END;
go

--Lấy một Account--
CREATE PROC sp_getOneAccount 
(
	@uid INT
)
AS
BEGIN
    SELECT 
		"uid", 
		"user",
		"pass",
		"isSell",
		"isAdmin"
    FROM 
        "Account"
    WHERE 
        "uid"= @uid
END;
go

--Xoá Account--
CREATE PROC sp_DeleteAccount
(
	@uid INT
)
AS
BEGIN
    DELETE 
    FROM 
        "Account"
    WHERE
        "uid"= @uid
END;
go

--Thêm Account--
CREATE PROC sp_InsertAccount
(
	@user NVARCHAR(50),
	@pass NVARCHAr(50),
	@isSell INT,
	@isAdmin INT
)
AS
	INSERT INTO "Account"("user","pass","isSell","isAdmin")
	VALUES (@user,@pass,@isSell,@isAdmin)

go


--Cập nhật Account--
CREATE PROC sp_UpdateAccount
(
	@uid INT,
	@user NVARCHAR(50),
	@pass NVARCHAr(50),
	@isSell INT,
	@isAdmin INT
)
AS
	UPDATE "Account" SET 
					"user" = @user,
					"pass" = @pass,
					"isSell" = @isSell,
					"isAdmin" = @isAdmin
	WHERE "uid" = @uid

go

--------------Bill-----------------

--lấy tất cả Bill---
CREATE PROC sp_getAllBill
AS
BEGIN
    SELECT 
		"bid", 
		"totalMoney",
		"discount",
		"createDate",
		"startDate",
		"State"
    FROM 
        "Bill"
    ORDER BY 
        "bid";
END;
go

--Lấy một Bill--
CREATE PROC sp_getOneBill
(
	@bid INT
)
AS
BEGIN
    SELECT 
		"bid", 
		"totalMoney",
		"discount",
		"startDate",
		"createDate",
		"State"
    FROM 
        "Bill"
    WHERE 
        "bid"= @bid
END;
go

--Xoá Bill--
CREATE PROC sp_DeleteBill
(
	@bid INT
)
AS
BEGIN
    DELETE 
    FROM 
        "Bill"
    WHERE
        "bid"= @bid
END;
go

--Thêm Bill--
CREATE PROC sp_InsertBill
(
	@bid INT,
	@totalMoney INT,
	@discount INT,
	@startDate DATE,
	@createDate DATE,
	@State NVARCHAR(50)
)
AS
	INSERT INTO "Bill"("bid","totalMoney","discount","startDate","createDate","State")
	VALUES (@bid,@totalMoney,@discount,@startDate,@createDate,@State)
go

--Cập nhật Bill--
CREATE PROC sp_UpdateBill
(
	@bid INT,
	@totalMoney INT,
	@discount INT,
	@startDate DATE,
	@createDate DATE,
	@State NVARCHAR(50)
)
AS
	UPDATE "Bill" SET 
					"totalMoney" = @totalMoney,
					"discount" = @discount,
					"startDate" = @startDate,
					"createDate" = @createDate,
					"State" = @State
	WHERE "bid" = @bid
go

--------------Category-----------------

--lấy tất cả Category---
CREATE PROC sp_getAllCategory
AS
BEGIN
    SELECT 
		"cid", 
		"cname"
    FROM 
        "Category"
    ORDER BY 
        "cid";
END;
go

--Lấy một Category--
CREATE PROC sp_getOneCategory
(
	@cid INT
)
AS
BEGIN
    SELECT 
		"cid", 
		"cname"
    FROM 
        "Category"
    WHERE 
        "cid"= @cid
END;
go

--Xoá Category--
CREATE PROC sp_DeleteCategory
(
	@cid INT
)
AS
BEGIN
    DELETE 
    FROM 
        "Category"
    WHERE
        "cid"= @cid
END;
go

--Thêm Category--
CREATE PROC sp_InsertCategory
(
	@cid INT,
	@cname NVARCHAR(50)
)
AS
	INSERT INTO "Category"("cid","cname")
	VALUES (@cid,@cname)
go

--Cập nhật Category--
CREATE PROC sp_UpdateCategory
(
	@cid INT,
	@cname NVARCHAR(50)
)
AS
	UPDATE "Category" SET 
					"cname" = @cname
	WHERE "cid" = @cid
go

-------------DetailOrder------------------

--lấy tất cả DetailOrder---
CREATE PROC sp_getAllDetailOrder
AS
BEGIN
    SELECT 
		"oid", 
		"pid",
		"Quantity"
    FROM 
        "DetailOrder"
    ORDER BY 
        "oid";
END;
go

--Lấy một DetailOrder--
CREATE PROC sp_getOneDetailOrder
(
	@oid INT,
	@pid INT
)
AS
BEGIN
    SELECT 
		"oid", 
		"pid",
		"Quantity"
    FROM 
        "DetailOrder"
    WHERE 
        "oid"= @oid AND "pid"= @pid
END;
go

--Xoá DetailOrder--
CREATE PROC sp_DeleteDetailOrder
(
	@oid INT,
	@pid INT
)
AS
BEGIN
    DELETE 
    FROM 
        "DetailOrder"
    WHERE
        "oid"= @oid AND "pid"= @pid 
END;
go

--Thêm DetailOrder--
CREATE PROC sp_InsertDetailOrder
(
	@oid INT,
	@pid INT,
	@Quantity INT
)
AS
	INSERT INTO "DetailOrder"("oid","pid","Quantity")
	VALUES (@oid,@pid,@Quantity)
go

--Cập nhật DetailOrder--
CREATE PROC sp_UpdateDetailOrder
(
	@oid INT,
	@pid INT,
	@Quantity INT
)
AS
	UPDATE "DetailOrder" SET 
					"Quantity" = @Quantity
	WHERE "oid" = @oid AND "pid" = @pid
go

--------------Member-----------------

--lấy tất cả Member---
CREATE PROC sp_getAllMember
AS
BEGIN
    SELECT 
		"mid", 
		"name",
		"age",
		"email",
		"phone",
		"address"
    FROM 
        "Member"
    ORDER BY 
        "mid";
END;
go

--Lấy một Member--
CREATE PROC sp_getOneMember
(
	@mid INT
)
AS
BEGIN
    SELECT 
		"mid", 
		"name",
		"age",
		"email",
		"phone",
		"address"
    FROM 
        "Member"
    WHERE 
        "mid"= @mid
END;
go

--Xoá Member--
CREATE PROC sp_DeleteMember
(
	@mid INT
)
AS
BEGIN
    DELETE 
    FROM 
        "Member"
    WHERE
        "mid"= @mid
END;
go

--Thêm Member--
CREATE PROC sp_InsertMember
(
	@mid INT,
	@name NVARCHAR(50),
	@age INT,
	@email NVARCHAR(50),
	@phone NVARCHAR(50),
	@address NVARCHAR(50)
)
AS
	INSERT INTO "Member"("mid","name","age","email","phone","address")
	VALUES (@mid,@name,@age,@email,@phone,@address)
go

--Cập nhật Member--
CREATE PROC sp_UpdateMember
(
	@mid INT,
	@name NVARCHAR(50),
	@age INT,
	@email NVARCHAR(50),
	@phone NVARCHAR(50),
	@address NVARCHAR(50)
)
AS
	UPDATE "Member" SET 
					"name" = @name,
					"age" = @age,
					"email" = @email,
					"phone" = @phone,
					"address" = @address
	WHERE "mid" = @mid
go

--------------Order-----------------

--lấy tất cả Order---
CREATE PROC sp_getAllOrder
AS
BEGIN
    SELECT 
		"oid", 
		"uid",
		"totalQuantity",
		"totalMoney",
		"purchaseDate",
		"address",
		"email",
		"phone",
		"state"
    FROM 
        "Order"
    ORDER BY 
        "oid";
END;
go

--Lấy một Order--
CREATE PROC sp_getOneOrder
(
	@oid INT
)
AS
BEGIN
    SELECT 
		"oid", 
		"uid",
		"totalQuantity",
		"totalMoney",
		"purchaseDate",
		"address",
		"email",
		"phone",
		"state"
    FROM 
        "Order"
    WHERE 
        "oid"= @oid
END;
go

--Xoá Order--
CREATE PROC sp_DeleteOrder
(
	@oid INT
)
AS
BEGIN
    DELETE 
    FROM 
        "Order"
    WHERE
        "oid"= @oid
END;
go

--Thêm Order--
CREATE PROC sp_InsertOrder
(
	@uid INT,
	@totalQuantity INT,
	@totalMoney INT,
	@purchaseDate DATE,
	@address NVARCHAR(50),
	@email NVARCHAR(50),
	@phone NVARCHAR(50),
	@state NVARCHAR(50)
)
AS
	INSERT INTO "Order"("uid","totalQuantity","totalMoney"
	,"purchaseDate","address","email","phone","state")
	VALUES (@uid, @totalQuantity, @totalMoney, @purchaseDate
	,@address, @email, @phone,@state)
go

--Cập nhật Order--
CREATE PROC sp_UpdateOrder
(
	@oid INT,
	@uid INT,
	@totalQuantity INT,
	@totalMoney INT,
	@purchaseDate DATE,
	@address NVARCHAR(50),
	@email NVARCHAR(50),
	@phone NVARCHAR(50),
	@state NVARCHAR(50)
)
AS
	UPDATE "Order" SET 
					"uid" = @uid,
					"totalQuantity" = @totalQuantity,
					"totalMoney" = @totalMoney,
					"purchaseDate" = @purchaseDate,
					"address" = @address,
					"email" = @email,
					"phone" = @phone,
					"state" = @state
	WHERE "oid" = @oid
go

--------------Product-----------------

--lấy tất cả Product---
CREATE PROC sp_getAllProduct
AS
BEGIN
    SELECT 
		"id", 
		"name",
		"image",
		"price",
		"title",
		"description",
		"cateID",
		"sale_ID"
    FROM 
        "Product"
    ORDER BY 
        "id";
END;
go

--Lấy một Product--
CREATE PROC sp_getOneProduct
(
	@id INT
)
AS
BEGIN
    SELECT 
		"id", 
		"name",
		"image",
		"price",
		"title",
		"description",
		"cateID",
		"sale_ID"
    FROM 
        "Product"
    WHERE 
        "id"= @id
END;
go

--Xoá Product--
CREATE PROC sp_DeleteProduct
(
	@id INT
)
AS
BEGIN
    DELETE 
    FROM 
        "Product"
    WHERE
        "id"= @id
END;
go

--Thêm Product--
CREATE PROC sp_InsertProduct
(
	@name NVARCHAR(50),
	@image NVARCHAR(MAX),
	@price FLOAT,
	@title NVARCHAR(50),
	@description NVARCHAR(50),
	@cateID INT,
	@sale_ID INT
)
AS
	INSERT INTO "Product"("name","image","price","title"
	,"description","cateID","sale_ID")
	VALUES (@name,@image,@price,@title,@description,@cateID,@sale_ID)
go

--Cập nhật Product--
CREATE PROC sp_UpdateProduct
(
	@id INT,
	@name NVARCHAR(50),
	@image NVARCHAR(MAX),
	@price FLOAT,
	@title NVARCHAR(50),
	@description NVARCHAR(50),
	@cateID INT,
	@sale_ID INT
)
AS
	UPDATE "Product" SET 
					"name" = @name,
					"image" = @image,
					"price" = @price,
					"title" = @title,
					"description" = @description,
					"cateID" = @cateID,
					"sale_ID" = @sale_ID
	WHERE "id" = @id
Go

---Tìm các sảm phẩm mà một tài khoản đó bán---
CREATE PROC sp_getProductBySaleID
(
	@uid INT
)
AS 
	SELECT * FROM Product p WHERE p.sale_ID = @uid
go

---Thêm đơn hàng khi nhấn nút thanh toán---
CREATE PROC sp_InsertOrderWithDetail
(
	@uid INT
)
AS
BEGIN 
	DECLARE @address NVARCHAR(50);
	DECLARE @email NVARCHAR(50);
	DECLARE @phone NVARCHAR(50);
	DECLARE @state NVARCHAR(50);
	DECLARE @lastID INT;
	SET @lastID = NULL;
	SET @state = 'created';

	SELECT @email = m.email,@phone=m.phone, @address = m."address"
	FROM Member m
	WHERE m.mid = @uid

    INSERT INTO "Order"("uid","totalMoney","totalQuantity","address","email","phone","state")
	VALUES (@uid,0,0,@address, @email, @phone,@state);
END;
go

--Lấy sản phẩm mới nhất
CREATE PROC sp_getLastProduct
AS
BEGIN
   select top 1 * 
   from Product
   order by id desc;
END;
go

--Tự động tạo người dùng và phân quyền trong Database
CREATE OR ALTER PROC USP_CREATE_LOGIN_USER
(
	@Role_Name NVARCHAR(50),
	@Login_Name NVARCHAR(50), 
	@Password_Login NVARCHAR(50)
)
AS
BEGIN
    DECLARE @Login_UserName VARCHAR(50),
			@QueryLogin VARCHAR(100),
			@QueryUser VARCHAR(100)

	SET @Login_UserName = @Login_Name
	SET @QueryLogin ='CREATE LOGIN ' + @Login_UserName + ' WITH PASSWORD = ' + QUOTENAME(@Password_Login, '''')
	SET @QueryUser = CONCAT('CREATE USER ', @Login_UserName, ' FOR LOGIN ', @Login_UserName);

	EXEC (@QueryLogin)
	EXEC (@QueryUser)

	EXEC sys.sp_addrolemember @rolename = @Role_Name, 
	                          @membername = @Login_Name 
END
GO

---Function---

---Tìm tên sản phẩm khi nhập gần đúng tên---
CREATE FUNCTION fn_SearchProductName(@name NVARCHAR(100))
RETURNS TABLE
AS RETURN SELECT * FROM Product WHERE "name" LIKE '%'+@name+'%'

GO


--Tìm giá của sản phẩm cao nhất trong từng danh mục--
CREATE FUNCTION fn_SearchMaxPriceByCategory()
RETURNS TABLE
AS RETURN 
	SELECT c.cname, MAX(p.price) AS maxPrice
	FROM Product p, Category c
	WHERE p.cateID= c.cid
	GROUP BY c.cname

GO

--Tìm những sản phẩm trong tầm giá---
CREATE FUNCTION fn_ProductInRangePrice(@min FLOAT, @max FLOAT)
RETURNS TABLE
AS RETURN 
	SELECT *
	FROM Product p
	WHERE p.price >@min AND p.price<@max
GO

--Tìm tất cả các sản phẩm theo tên danh mục--
CREATE FUNCTION fn_ProductByCateName(@name NVARCHAR(50))
RETURNS TABLE
AS RETURN 
	SELECT *
	FROM Product p,Category c
	WHERE p.cateID = c.cid AND c."cname" LIKE '%'+@name+'%'
GO

--Tìm tất cả các sản phẩm theo tên của người bán--
CREATE FUNCTION fn_ProductBySalerName(@name NVARCHAR(50))
RETURNS TABLE
AS RETURN 
	SELECT m."name" AS NguoiBan, p."name" AS SanPham
	FROM Product p,Member m
	WHERE p.sale_ID = m.mid AND m."name" LIKE '%'+@name+'%'
GO

---Tìm những sản phẩm và số tiền mà người bán đã bán được ---
CREATE FUNCTION fn_ProductAndAmount(@name NVARCHAR(50))
RETURNS TABLE
AS RETURN 
	SELECT p."name",SUM(d.Quantity) AS Quantity, SUM(p.price*d.Quantity) AS Amount
	FROM Product p,DetailOrder d, Member m
	WHERE p.id = d.pid AND p.sale_ID = m.mid AND m."name" LIKE '%'+@name+'%'
	GROUP BY p."name"
GO

---Danh sach cac mat hang trong hoa don---
CREATE FUNCTION fn_HoaDon(@oid INT)
RETURNS TABLE
AS RETURN 
	SELECT p."name",price
	FROM DetailOrder d, Product p
	WHERE d.oid = @oid AND d.pid = p.id
go

---Lấy ID của đơn hàng cuối cùng( mới nhất)----
CREATE FUNCTION fn_LastOrderID()
RETURNS INT
AS 
BEGIN
	DECLARE @lastID INT;
	SELECT @lastID = MAX(oid)
	FROM "Order"
	RETURN @lastID
END

