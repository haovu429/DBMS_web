package entity;

public class DetailOrder {
	int oid;
	int pid;
	int quantity;
	public int getOid() {
		return oid;
	}
	public void setOid(int oid) {
		this.oid = oid;
	}
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public DetailOrder(int oid, int pid, int quantity) {
		super();
		this.oid = oid;
		this.pid = pid;
		this.quantity = quantity;
	}
	@Override
	public String toString() {
		return "OrderDetail [oid=" + oid + ", pid=" + pid + ", quantity=" + quantity + "]";
	}
	

}
