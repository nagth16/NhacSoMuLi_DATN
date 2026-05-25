<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>500 - Lỗi máy chủ hệ thống</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bg:       #080a0f;
            --card:     #111520;
            --border:   #1c2236;
            --accent:   #ff5fa0;
            --accent2:  #ff3b30;
            --glow:     rgba(255,95,160,0.3);
            --text:     #eef0f6;
            --muted:    #5a6282;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: var(--bg);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        .bg-gradient {
            position: absolute; inset: 0; z-index: 0;
            background:
                radial-gradient(circle at 30% 30%, rgba(255,95,160,0.1) 0%, transparent 50%),
                radial-gradient(circle at 70% 70%, rgba(108,99,255,0.08) 0%, transparent 50%);
        }

        .container {
            position: relative; z-index: 1;
            text-align: center;
            padding: 40px;
            max-width: 500px;
            width: 100%;
        }

        .error-code {
            font-family: 'Syne', sans-serif;
            font-size: 130px;
            font-weight: 800;
            line-height: 1;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            letter-spacing: -6px;
            animation: pulse 3s infinite alternate;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            100% { transform: scale(1.03); }
        }

        h2 {
            font-family: 'Syne', sans-serif;
            font-size: 26px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 12px;
        }

        p {
            font-size: 15px;
            color: var(--muted);
            line-height: 1.6;
            margin-bottom: 32px;
        }

        .btn-home {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 14px 28px;
            background: linear-gradient(135deg, var(--accent), #ff3b30);
            border: none;
            border-radius: 50px;
            color: #fff;
            font-family: 'Syne', sans-serif;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            box-shadow: 0 8px 24px var(--glow);
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }

        .btn-home:hover {
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 12px 32px var(--glow);
        }

        .btn-home:active {
            transform: translateY(0) scale(1);
        }

        .vinyl-decor {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: radial-gradient(circle at center, #111520 20%, #1c2236 40%, #080a0f 60%);
            border: 2px dashed var(--border);
            margin: 0 auto 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            animation: spin 8s linear infinite;
            box-shadow: 0 0 30px rgba(255,95,160,0.1);
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="bg-gradient"></div>
    <div class="container">
        <div class="vinyl-decor">🛠</div>
        <div class="error-code">500</div>
        <h2>Lỗi máy chủ hệ thống</h2>
        <p>Đã xảy ra sự cố ngoài ý muốn từ phía máy chủ hệ thống. Vui lòng thử lại sau giây lát.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn-home">
            🏠 Quay lại trang chủ
        </a>
    </div>
</body>
</html>