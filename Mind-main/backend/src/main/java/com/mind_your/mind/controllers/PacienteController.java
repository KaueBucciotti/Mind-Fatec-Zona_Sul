package com.mind_your.mind.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mind_your.mind.dto.request.PacienteCadastroRequestDTO;
import com.mind_your.mind.dto.request.PacienteLoginRequestDTO;
import com.mind_your.mind.dto.request.PacienteUpdateRequestDTO;
import com.mind_your.mind.dto.response.JwtResponseDTO;
import com.mind_your.mind.dto.response.PacienteCadastroResponseDTO;
import com.mind_your.mind.dto.response.PacienteResponseDTO;
import com.mind_your.mind.dto.response.PacienteSessionResponseDTO;
import com.mind_your.mind.dto.response.PacienteConfiguracoesResponseDTO;
import com.mind_your.mind.dto.response.UploadImagemResponseDTO;
import java.util.Optional;
import com.mind_your.mind.mapper.PacienteMapper; // Added import
import com.mind_your.mind.repository.PacienteRepository;
import com.mind_your.mind.service.PacienteService;
import com.mind_your.mind.models.Paciente;

@RestController
@RequestMapping("/pacientes")
public class PacienteController {

    private final PacienteRepository pacienteRepository;

    @Autowired
    private PacienteService pacienteService;

    public PacienteController(PacienteRepository pacienteRepository) {
        this.pacienteRepository = pacienteRepository;
    }

    // Cadastrar
    @PostMapping("/cadastrar")
    public ResponseEntity<PacienteCadastroResponseDTO> cadastrar(
            @RequestBody PacienteCadastroRequestDTO dados) {

        return ResponseEntity.ok(pacienteService.cadastrar(dados));
    }

    // buscar todos
    @GetMapping
    public ResponseEntity<List<PacienteResponseDTO>> listarTodos() {
        return ResponseEntity.ok(pacienteService.buscarTodos());
    }

    // Buscar por email
    @GetMapping("/email/{email}")
    public ResponseEntity<PacienteResponseDTO> buscarUsuarioPorEmail(@PathVariable String email) {
        return pacienteService.buscarPorEmail(email)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    

    // Buscar por nome
    @GetMapping("/nome/{nome}")
    public ResponseEntity<PacienteResponseDTO> buscarPorNome(@PathVariable("nome") String nome) {
        return pacienteService.buscarPorNome(nome)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar SESSÃO por login (email ou nome de usuário) - Retorna apenas dados essenciais de login
    @GetMapping("/login/{login}")
    public ResponseEntity<PacienteSessionResponseDTO> buscarSessaoPorLogin(@PathVariable("login") String login) {
        return pacienteService.buscarSessaoPorLogin(login)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar por ID
    @GetMapping("/{id}")
    public ResponseEntity<PacienteResponseDTO> buscarPorId(@PathVariable("id") String id) {
        return pacienteService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar configurações por ID
    @GetMapping("/{id}/configuracoes")
    public ResponseEntity<PacienteConfiguracoesResponseDTO> buscarConfiguracoes(@PathVariable("id") String id) {
        return pacienteService.buscarConfiguracoesPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Atualizar
    @PutMapping("/{id}")
    public ResponseEntity<PacienteResponseDTO> atualizar(
            @PathVariable("id") String id,
            @RequestBody PacienteUpdateRequestDTO dados) {

        return pacienteService.atualizar(id, dados)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // Deletar por ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable("id") String id) {
        return pacienteService.deletarPorId(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

    @PostMapping("/login")
    public ResponseEntity<JwtResponseDTO> login(@RequestBody PacienteLoginRequestDTO dados) {
        return pacienteService.fazerLogin(dados.getLogin(), dados.getSenha())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(401).build());
    }

    @PostMapping("/{id}/imagem")
    public ResponseEntity<UploadImagemResponseDTO> uploadImagem(
            @PathVariable("id") String id,
            @RequestParam("imagem") MultipartFile file) {

        return pacienteService.uploadImagem(id, file)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
