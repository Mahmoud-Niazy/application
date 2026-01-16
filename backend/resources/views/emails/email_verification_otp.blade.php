<div style="font-family: Arial, sans-serif; background:#f6f7fb; padding:24px;">
    <div style="max-width:560px; margin:0 auto; background:#ffffff; border:1px solid #e6e8ef; border-radius:12px; overflow:hidden;">
        <div style="padding:18px 20px; background:#111827; color:#ffffff;">
            <div style="font-size:16px; font-weight:700;">Email Verification</div>
        </div>
        <div style="padding:20px; color:#111827;">
            <p style="margin:0 0 12px;">Hello {{ $name }},</p>
            <p style="margin:0 0 16px;">Use the code below to verify your email address:</p>
            <div style="font-size:28px; font-weight:800; letter-spacing:6px; text-align:center; padding:14px 0; background:#f3f4f6; border-radius:10px;">{{ $code }}</div>
            <p style="margin:16px 0 0; color:#6b7280; font-size:13px;">This code expires in 10 minutes.</p>
        </div>
    </div>
</div>
