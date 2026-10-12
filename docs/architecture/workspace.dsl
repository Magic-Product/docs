workspace "Сеть маникюрных салонов" {
    description "Система управления сетью маникюрных салонов"

    model {
        # Пользователи
        client = person "Клиент" "Записывается на услуги"
        admin = person "Администратор" "Управляет филиалами, мастерами, услугами"

        # Внешние системы
        nat = softwareSystem "NATS" "Брокер сообщений" {
            tags "External"
        }

        # Наша система
        salonSystem = softwareSystem "Salon System" "Система управления салонами" {
            gateway = container "API Gateway" "Единая точка входа" "Traefik"
            catalog = container "Catalog Service" "Услуги и филиалы" "Go, PostgreSQL"
            staff = container "Staff Service" "Мастера и расписания" "Go, PostgreSQL"
            customer = container "Customer Service" "Профили клиентов" "Go, PostgreSQL"
            booking = container "Booking Service" "Записи и слоты" "Go, PostgreSQL"
            finance = container "Finance Service" "Выручка и зарплаты" "Go, PostgreSQL"
        }

        # Связи
        client -> gateway "Использует"
        admin -> gateway "Использует"

        gateway -> catalog "HTTP"
        gateway -> staff "HTTP"
        gateway -> customer "HTTP"
        gateway -> booking "HTTP"
        gateway -> finance "HTTP"

        booking -> catalog "HTTP"
        booking -> staff "HTTP"
        booking -> customer "HTTP"
        booking -> nat "Публикует события"
        nat -> finance "Доставляет события"
    }

    views {
            systemContext salonSystem "SystemContext" {
                include *
                autoLayout
            }

            container salonSystem "Containers" {
                include *
                autoLayout
            }
        }
}