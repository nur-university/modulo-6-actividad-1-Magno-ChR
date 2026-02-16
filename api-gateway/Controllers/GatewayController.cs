using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using api_gateway.Services;
using System.Net.Http;

namespace api_gateway.Controllers
{
    [ApiController]
    [Route("api")]
    public class GatewayController : ControllerBase
    {
        private readonly ITokenGeneratorService _tokenGeneratorService;
        private readonly HttpClient _httpClient;

        public GatewayController(ITokenGeneratorService tokenGeneratorService, HttpClient httpClient)
        {
            _tokenGeneratorService = tokenGeneratorService;
            _httpClient = httpClient;
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            // Validar credenciales mockeadas
            if (request?.Username != "admin" || request?.Password != "admin")
            {
                return Unauthorized(new { message = "Credenciales inválidas" });
            }

            var token = _tokenGeneratorService.GenerateToken(request.Username);
            return Ok(new { token });
        }

        [HttpGet("users")]
        [Authorize]
        public async Task<IActionResult> GetUsers()
        {
            try
            {
                var response = await _httpClient.GetAsync("https://jsonplaceholder.typicode.com/users");
                response.EnsureSuccessStatusCode();
                var content = await response.Content.ReadAsStringAsync();
                return Content(content, "application/json");
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error al obtener usuarios", error = ex.Message });
            }
        }

        [HttpGet("posts")]
        [Authorize]
        public async Task<IActionResult> GetPosts()
        {
            try
            {
                var response = await _httpClient.GetAsync("https://jsonplaceholder.typicode.com/posts");
                response.EnsureSuccessStatusCode();
                var content = await response.Content.ReadAsStringAsync();
                return Content(content, "application/json");
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error al obtener posts", error = ex.Message });
            }
        }
    }

    public class LoginRequest
    {
        public string? Username { get; set; }
        public string? Password { get; set; }
    }
}
