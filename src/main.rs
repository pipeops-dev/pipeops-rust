use actix_web::{web, App, HttpResponse, HttpServer, Responder};
use std::env;

async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello, world!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let port = env::var("PORT").unwrap_or_else(|_| String::from("8080")); // Default to 8080 if PORT not found

    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(hello))
    })
    .bind(format!("0.0.0.0:{}", port))?
    .run()
    .await
}
