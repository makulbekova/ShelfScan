using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ShelfScan.Data;
using ShelfScan.Models;
using System.Diagnostics;

namespace ShelfScan.Controllers
{
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            DateTime todayUtc = DateTime.UtcNow.Date;

            int numberOfScansToday = await _context.ApiScans
                .Where(s => s.ScanDatetime.Year == todayUtc.Year &&
                            s.ScanDatetime.Month == todayUtc.Month &&
                            s.ScanDatetime.Day == todayUtc.Day)
                .CountAsync();

            int numberOfEmployees = await _context.ApiEmployees.CountAsync();

            int numberOfLocations = await _context.ApiLocations.CountAsync();

            ViewData["NumberOfScansToday"] = numberOfScansToday;
            ViewData["NumberOfEmployees"] = numberOfEmployees;
            ViewData["NumberOfLocations"] = numberOfLocations;

            return View();
        }


        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
