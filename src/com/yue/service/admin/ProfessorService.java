package com.yue.service.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.yue.entity.admin.Professor;

@Service
public interface ProfessorService {
	public List<Professor> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Professor professor);
	public int edit(Professor professor);
	public int delete(String str);
}
