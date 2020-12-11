package com.yue.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yue.entity.admin.Grade;

@Repository
public interface GradeDao {
	public Grade findByCidAndSid(Long cid, Long sid);
	public List<Grade> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Grade grade);
	public int edit(Grade grade);
	public int delete(String str);
}
