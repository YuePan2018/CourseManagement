package com.yue.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.yue.entity.admin.Grade;

@Service
public interface GradeService {
	public Grade findByCidAndSid(Long cid, Long sid);
	public List<Grade> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Grade grade);
	public int edit(Grade grade);
	public int delete(String str);
}
