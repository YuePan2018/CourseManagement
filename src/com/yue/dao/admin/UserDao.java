package com.yue.dao.admin;

import org.springframework.stereotype.Repository;

import com.yue.entity.admin.User;

@Repository
public interface UserDao {
	public User findByUsername(String username);
	public int add(User user);
}
