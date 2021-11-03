package entity;


public class MyAccount {
	int mid;
	String name;
	int age;
	String email;
	String phone;
	String address;
	String user_name;
	public int getMid() {
		return mid;
	}
	public void setMid(int mid) {
		this.mid = mid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	@Override
	public String toString() {
		return "MyAccount [mid=" + mid + ", name=" + name + ", age=" + age + ", email=" + email + ", phone=" + phone
				+ ", address=" + address + ", user_name=" + user_name + "]";
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public MyAccount(int mid, String name, int age, String email, String phone, String address, String user_name) {
		super();
		this.mid = mid;
		this.name = name;
		this.age = age;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.user_name = user_name;
	}
	

}
