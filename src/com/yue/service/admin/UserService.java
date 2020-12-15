package com.yue.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.yue.entity.admin.User;

@Service
public interface UserService {
	public User findByUsername(String username);
	public User findByID(Long id);
	public List<User> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(User user);
	public int edit(User user);
	public int delete(String str);
}
