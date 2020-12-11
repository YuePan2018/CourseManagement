package com.yue.entity.admin;

import org.springframework.stereotype.Component;

@Component
public class Course {
	private Long id;
	private String title;
	private Long pid;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Long getPid() {
		return pid;
	}
	public void setPid(Long pid) {
		this.pid = pid;
	}	
}
