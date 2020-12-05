package com.yue.service.admin;

import org.springframework.stereotype.Service;

import com.yue.entity.admin.User;

@Service
public interface UserService {
	public User findByUsername(String username);
	public int add(User user);
}
