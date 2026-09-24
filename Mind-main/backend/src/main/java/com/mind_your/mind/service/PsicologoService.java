package com.mind_your.mind.service;

import com.mind_your.mind.dto.request.PsicologoCadastroRequestDTO;
import com.mind_your.mind.dto.request.PsicologoUpdateRequestDTO;
import com.mind_your.mind.dto.response.JwtResponseDTO;
import com.mind_your.mind.dto.response.PsicologoCadastroResponseDTO;
import com.mind_your.mind.dto.response.PsicologoResponseDTO;
import com.mind_your.mind.dto.response.UploadImagemResponseDTO;
import com.mind_your.mind.mapper.PsicologoMapper;
import com.mind_your.mind.models.Psicologo;
import com.mind_your.mind.models.RefreshToken;
import com.mind_your.mind.repository.PsicologoRepository;
import com.mind_your.mind.security.JwtUtil;
import com.mind_your.mind.dto.response.PsicologoConfiguracoesResponseDTO;
import com.mind_your.mind.security.UserDetailsImpl;
import org.springframework.security.core.Authentication;
import com.mind_your.mind.dto.response.PsicologoSessionResponseDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class PsicologoService {

    @Autowired
    private PsicologoRepository psicologoRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private RefreshTokenService refreshTokenService;

    @Autowired
    private EnderecoService enderecoService;

    // Cadastrar
    public PsicologoCadastroResponseDTO cadastrar(PsicologoCadastroRequestDTO dados) {
        Psicologo psicologo = new Psicologo();

        psicologo.setNome(dados.getNome());
        psicologo.setSobrenome(dados.getSobrenome());
        psicologo.setEmail(dados.getEmail());
        psicologo.setLogin(
                (dados.getLogin() == null || dados.getLogin().isEmpty())
                        ? dados.getEmail()
                        : dados.getLogin());
        psicologo.setSenha(passwordEncoder.encode(dados.getSenha()));
        psicologo.setCrp(dados.getCrp());
        psicologo.setEspecialidades(dados.getEspecialidades());
        psicologo.setNumeroResidencia(dados.getNumeroResidencia());

        if (dados.getCep() != null){
            enderecoService.obtemEnderecoPorCep(dados.getCep()).ifPresent(dadosEndereco -> {
                psicologo.setCep(dados.getCep());
                psicologo.setCidade(dadosEndereco.getCidade());
                psicologo.setEndereco(dadosEndereco.getLogradouro());
                psicologo.setUf(dadosEndereco.getUf());
            });
        }

        Psicologo salvo = psicologoRepository.save(psicologo);
        return PsicologoMapper.toCadastroResponseDTO(salvo);
    }

    // Buscar todos
    public List<PsicologoResponseDTO> buscarTodos() {
        return psicologoRepository.findAll()
                .stream()
                .map(PsicologoMapper::toResponseDTO)
                .toList();
    }

    // Buscar por ID
    public Optional<PsicologoResponseDTO> buscarPorId(String id) {
        return psicologoRepository.findById(id)
                .map(PsicologoMapper::toResponseDTO);
    }

    // Buscar configurações por ID
    public Optional<PsicologoConfiguracoesResponseDTO> buscarConfiguracoesPorId(String id) {
        checarPropriedade(id);
        return psicologoRepository.findById(id)
                .map(PsicologoMapper::toConfiguracoesResponseDTO);
    }

    // Buscar por email
    public Optional<PsicologoResponseDTO> buscarPorEmail(String email) {
        return psicologoRepository.findByEmail(email)
                .map(PsicologoMapper::toResponseDTO);
    }

    // Buscar por nome
    public Optional<PsicologoResponseDTO> buscarPorNome(String nome) {
        return psicologoRepository.findByNome(nome)
                .map(PsicologoMapper::toResponseDTO);
    }

    // Buscar por login (email ou username)
    public Optional<PsicologoResponseDTO> buscarPorLogin(String login) {
        return buscarPorLoginAuth(login)
                .map(PsicologoMapper::toResponseDTO);
    }

    // Atualizar
    public Optional<PsicologoResponseDTO> atualizar(String id, PsicologoUpdateRequestDTO dados) {
        checarPropriedade(id);
        return psicologoRepository.findById(id).map(psicologo -> {
            PsicologoMapper.updatePsicologoFromDTO(dados, psicologo, passwordEncoder);
            Psicologo atualizado = psicologoRepository.save(psicologo);
            return PsicologoMapper.toResponseDTO(atualizado);
        });
    }

    // Deletar por ID
    public boolean deletarPorId(String id) {
        checarPropriedade(id);
        if (psicologoRepository.existsById(id)) {
            psicologoRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // Login com JWT
    public Optional<JwtResponseDTO> fazerLogin(String login, String senha) {
        return buscarPorLoginAuth(login)
                .filter(p -> passwordEncoder.matches(senha, p.getSenha()))
                .map(p -> {
                    Authentication authentication = authenticationManager.authenticate(
                            new UsernamePasswordAuthenticationToken(p.getLogin(), senha));
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    String token = jwtUtil.generateJwtToken(authentication);
                    RefreshToken refreshToken = refreshTokenService.criar(p.getLogin());
                    return new JwtResponseDTO(token, p.getLogin(), "psicologo", refreshToken.getToken());
                });
    }

    // Upload de imagem de perfil
    public Optional<UploadImagemResponseDTO> uploadImagem(String id, MultipartFile file) {
        checarPropriedade(id);
        try {
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                throw new RuntimeException("Arquivo deve ser uma imagem");
            }

            if (file.getSize() > 5 * 1024 * 1024) {
                throw new RuntimeException("Imagem deve ter no máximo 5MB");
            }

            Optional<Psicologo> psicologoOpt = psicologoRepository.findById(id);
            if (psicologoOpt.isEmpty()) {
                return Optional.empty();
            }

            Psicologo psicologo = psicologoOpt.get();

            Path uploadPath = Paths.get("uploads/users-pictures").toAbsolutePath().normalize();
            Files.createDirectories(uploadPath);

            // Deletar imagem antiga
            if (psicologo.getImgPerfil() != null && !psicologo.getImgPerfil().isEmpty()) {
                Path oldImage = uploadPath.resolve(psicologo.getImgPerfil());
                Files.deleteIfExists(oldImage);
            }

            // Gerar nome único
            String originalFilename = file.getOriginalFilename();
            String extension = (originalFilename != null && originalFilename.contains("."))
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";

            String filename = "perfil-psi-" + psicologo.getLogin() + "-"
                    + UUID.randomUUID().toString().substring(0, 8) + extension;

            Path targetLocation = uploadPath.resolve(filename);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            psicologo.setImgPerfil(filename);
            psicologoRepository.save(psicologo);

            return Optional.of(new UploadImagemResponseDTO("Imagem enviada com sucesso", filename));

        } catch (Exception e) {
            throw new RuntimeException("Erro ao fazer upload da imagem", e);
        }
    }

    // Buscar Sessao por login
    public Optional<PsicologoSessionResponseDTO> buscarSessaoPorLogin(String login) {
        return buscarPorLoginAuth(login).map(PsicologoMapper::toSessionDTO);
    }

    // Método interno de busca por login ou email
    private Optional<Psicologo> buscarPorLoginAuth(String login) {
        if (login.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return psicologoRepository.findByEmail(login);
        }
        return psicologoRepository.findByLogin(login);
    }

    private void checarPropriedade(String id) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserDetailsImpl) {
            UserDetailsImpl user = (UserDetailsImpl) auth.getPrincipal();
            if (!user.getId().equals(id)) {
                throw new RuntimeException("Acesso negado: Você não tem permissão para acessar ou modificar dados de outro usuário.");
            }
        }
    }
}