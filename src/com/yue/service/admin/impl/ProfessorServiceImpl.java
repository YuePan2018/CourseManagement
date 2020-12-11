package com.yue.service.admin.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yue.dao.admin.ProfessorDao;
import com.yue.entity.admin.Professor;
import com.yue.service.admin.ProfessorService;

@Service
public class ProfessorServiceImpl implements ProfessorService {
	@Autowired
	private ProfessorDao professorDao;
	@Override
	public int add(Professor professor) {		
		return professorDao.add(professor);
	}

	@Override
	public List<Professor> findList(Map<String, Object> queryMap) {
		return professorDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return professorDao.getTotal(queryMap);
	}

	@Override
	public int edit(Professor professor) {
		return professorDao.edit(professor);
	}

	@Override
	public int delete(String str) {
		return professorDao.delete(str);
	}

}
