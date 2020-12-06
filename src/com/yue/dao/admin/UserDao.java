package com.yue.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yue.entity.admin.User;

@Repository
public interface UserDao {
	public User findByUsername(String username);
	public List<User> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(User user);
	public int edit(User user);
}
