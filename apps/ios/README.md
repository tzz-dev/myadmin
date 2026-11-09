# MyAdmin iOS

SwiftUI 原生应用,通过 `apps/api` 访问数据。

```bash
brew install xcodegen
xcodegen            # 由 project.yml 生成 MyAdmin.xcodeproj
open MyAdmin.xcodeproj
```

- API 地址:`project.yml` 里的 `API_BASE_URL`(模拟器可直接用 localhost;真机需改成电脑局域网 IP)。
- `Models.swift` 需手动与 `packages/db/src/schema.ts` 保持一致。
