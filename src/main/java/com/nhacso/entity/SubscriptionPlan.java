package com.nhacso.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "subscription_plan")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SubscriptionPlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plan_id")
    private Long planId;

    @Column(name = "plan_name", nullable = false, length = 100)
    private String planName;

    @Column(name = "price", nullable = false, precision = 18, scale = 2)
    private BigDecimal price;

    // Thời hạn gói, ví dụ: 30 ngày, 90 ngày, 365 ngày
    @Column(name = "duration", nullable = false)
    private Integer duration;
}
