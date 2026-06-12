package com.nhacso.controller;

import com.nhacso.dao.UserDAO;
import com.nhacso.entity.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserDAO userDAO;

    public UserController(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    @PostMapping("/{id}/premium")
    public ResponseEntity<Map<String, Object>> togglePremium(@PathVariable Integer id) {
        User user = userDAO.findById(id);
        if (user == null) {
            return ResponseEntity.notFound().build();
        }
        boolean newPremium = user.getPremium() == null || !user.getPremium();
        user.setPremium(newPremium);
        userDAO.update(user);
        return ResponseEntity.ok(Map.of("premium", newPremium));
    }
}
