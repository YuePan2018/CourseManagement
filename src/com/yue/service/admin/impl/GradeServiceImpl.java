package com.yue.service.admin.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yue.dao.admin.GradeDao;
import com.yue.entity.admin.Grade;
import com.yue.service.admin.GradeService;

@Service
public class GradeServiceImpl implements GradeService {
	@Autowired
	private GradeDao gradeDao;
	
	@Override
	public Grade findByCidAndSid(Long cid, Long sid) {
		return gradeDao.findByCidAndSid(cid, sid);
	}

	@Override
	public int add(Grade grade) {		
		return gradeDao.add(grade);
	}

	@Override
	public List<Grade> findList(Map<String, Object> queryMap) {
		return gradeDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return gradeDao.getTotal(queryMap);
	}

	@Override
	public int edit(Grade grade) {
		return gradeDao.edit(grade);
	}

	@Override
	public int delete(String str) {
		return gradeDao.delete(str);
	}

}
