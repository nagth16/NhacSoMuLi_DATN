package com.nhacso.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Service
public class VietQRService {

    @Value("${vietqr.bank.bin}")
    private String bankBin;

    @Value("${vietqr.bank.account}")
    private String bankAccount;

    @Value("${vietqr.bank.name}")
    private String bankName;

    public String generateTransactionRef() {
        return "MULI" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public String generateQrImageUrl(String amount, String transactionRef) {
        return generateQrImageUrl(amount, transactionRef, transactionRef);
    }

    public String generateQrImageUrl(String amount, String transactionRef, String addInfoCustom) {
        String template = "qr_only";
        String addInfo = encode(addInfoCustom);
        return String.format(
                "https://img.vietqr.io/image/%s-%s-%s.jpg?amount=%s&addInfo=%s&accountName=%s",
                bankBin, bankAccount, template, amount, addInfo, encode(bankName)
        );
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
